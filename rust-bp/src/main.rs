use anyhow::Error;
use aptos::move_tool::CachedPackageRegistry;
use aptos_types::account_address::AccountAddress;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Error> {
    let url = Url::parse("https://mainnet.aptoslabs.com/v1/").unwrap();
    let address_str = "0xface729284ae5729100b3a9ad7f7cc025ea09739cd6e7252aff0beb53619cafe";
    let address = AccountAddress::from_hex_literal(address_str).unwrap();
    let registry = CachedPackageRegistry::create(url, address, true).await?;
    for ele in registry.package_names() {
        while let Ok(module) = registry.get_module(ele).await {
            println!("{:?}", module.name());
        }
        // println!("{:?}", (registry.get_package(ele).await?).module());
    }

    Ok(())

    // let path = std::env::current_dir()
    //     .ok()
    //     .unwrap()
    //     .join("src/bytecode.txt");
    // let txt = std::fs::read_to_string(path).ok().unwrap();
    // let hex_str = txt.strip_prefix("0x").unwrap();
    // let example_bytecode = hex::decode(hex_str).unwrap();
    // let module = CompiledModule::deserialize(&example_bytecode).unwrap();

    // for ele in module.immediate_dependencies_iter() {
    //     println!("{:?}", ele);
    // }

    // let modules = Modules::new(vec![&module]);

    // // std::println!("{:?}", module.struct_defs);
    // let _ = modules
    //     .compute_dependency_graph()
    //     .compute_topological_order()
    //     .unwrap()
    //     .map(|m| std::println!("{:?}", m));
}
