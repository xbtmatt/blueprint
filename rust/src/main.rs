use anyhow::Error;
use aptos_framework::natives::code::PackageRegistry;
use aptos_rest_client::Client;
use aptos_types::account_address::AccountAddress;
use move_binary_format::{access::ModuleAccess, CompiledModule};
use move_bytecode_utils::dependency_graph::DependencyGraph;
use move_decompiler::{Decompiler, Options};
use move_model::{metadata::LanguageVersion, model::GlobalEnv};
use std::collections::{BTreeMap, HashMap};
use url::Url;

macro_rules! log {
    ($val:expr) => {
        println!("{}", $val);
    };
}

// Build a map of packages.
//

// Decompiler needs a small fix for loading vector pkg:
// specifically in `binary_module_loader.rs`:
//
// if module_name == vector_module_name {
//     if let None = module_id {
//         // Find the vector module since it was added in a different iteration possibly.
//         if let Some(id) = env.find_module(&vector_module_name) {
//             module_id = Some(id.get_id());
//         }
//     }
// }

#[tokio::main]
async fn main() -> Result<(), Error> {
    let env = &mut GlobalEnv::new();
    let options = &mut Options {
        language_version: Option::Some(LanguageVersion::V2_1),
        no_conditionals: false,
        no_expressions: false,
        output_dir: String::from(""),
        ending: String::from("mv.move"),
        script: false,
        source_map_dir: String::from(""),
        inputs: vec![],
    };
    env.set_compiler_v2(true);

    let _arguments = "0x111f39f15da7e418cbb2188666eedd8e9bade9dae11cf949b0736c848025c111";
    let _wrapper = "0x222471173d5c6ecc1de17f28ed2c7cc4973544757e9f99f8a59d2065286ea222";
    let wrapper_consumer = "0x333062356efd6e60c36ce6d86bbb7d8fb3be5117e69fcb8dc9190e987a976333";
    let url = Url::parse("http://localhost:8080/v1/").unwrap();
    // let address_str = "0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe";
    // let address_str = "0xbabe32dbe1cb44c30363894da9f49957d6e2b94a06f2fc5c20a9d1b9e54cface";

    let address = AccountAddress::from_hex_literal(_wrapper).unwrap();
    let (_, bytecodes) = get_package_registry(url.clone(), address, true).await?;

    options
        .inputs
        .extend(bytecodes.clone().into_values().map(hex::encode));

    let module_map: &mut HashMap<String, CompiledModule> = &mut HashMap::new();

    let compiled_modules = &mut bytecodes
        .values()
        .map(|bc| CompiledModule::deserialize(bc).unwrap())
        .collect::<Vec<_>>();

    for module in compiled_modules.clone() {
        let name = module.self_name().to_string();
        module_map.entry(name).or_insert(module);
    }

    for module in compiled_modules.clone() {
        for ele in module.immediate_dependencies() {
            let (_, bytecodes) = get_package_registry(url.clone(), ele.address, true).await?;

            options
                .inputs
                .extend(bytecodes.clone().into_values().map(hex::encode));
            bytecodes
                .values()
                .map(|bc| CompiledModule::deserialize(bc).unwrap())
                .for_each(|m| {
                    let name = m.self_name().to_string();
                    module_map.entry(name).or_insert(m);
                });
        }
    }

    let deduplicated_modules: Vec<_> = module_map.clone().into_values().collect();
    let graph = DependencyGraph::new(deduplicated_modules.iter());
    let sorted = graph
        .compute_topological_order()
        .unwrap()
        .collect::<Vec<_>>();

    // graph.compute_topological_order().unwrap().for_each(|v| {
    //     log!(v.name().as_str());
    // });

    let mut decompiler = Decompiler::new(Default::default());

    for module in sorted {
        println!("-------------------------------------------------------------------------------");
        let name = &module.name();
        log!(format!(
            "{}::{}",
            module.self_addr().to_standard_string().as_str(),
            name.as_str()
        ));
        let unique_bytes: &mut Vec<u8> = &mut vec![];
        let _ = module.serialize(unique_bytes);
        let source_map = decompiler.empty_source_map(name.as_str(), unique_bytes);
        log!(decompiler.decompile_module(module.clone(), source_map));
    }

    Ok(())
}

pub async fn get_package_registry(
    url: Url,
    addr: AccountAddress,
    with_bytecode: bool,
) -> anyhow::Result<(PackageRegistry, BTreeMap<String, Vec<u8>>)> {
    let client = Client::new(url);
    // Need to use a different type to deserialize JSON
    let registry = client
        .get_account_resource_bcs::<PackageRegistry>(addr, "0x1::code::PackageRegistry")
        .await?
        .into_inner();
    let mut bytecode = BTreeMap::new();
    if with_bytecode {
        for pack in &registry.packages {
            for module in &pack.modules {
                let bytes = client
                    .get_account_module(addr, &module.name)
                    .await?
                    .into_inner()
                    .bytecode
                    .0;
                bytecode.insert(module.name.clone(), bytes);
            }
        }
    }
    Ok((registry, bytecode))
}
