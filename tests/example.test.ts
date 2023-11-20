// Copyright © Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

import {
  Account,
  AptosConfig,
  Network,
  Aptos,
  AccountAddress,
  Bool,
  U128,
  U16,
  U256,
  U32,
  U64,
  U8,
  TransactionFeePayerSignature,
  TransactionMultiAgentSignature,
  EntryFunctionArgumentTypes,
  SimpleEntryFunctionArgumentTypes,
  Ed25519PrivateKey,
  UserTransactionResponse,
  parseTypeTag,
  Hex,
  MoveValue,
  FixedBytes,
  MoveOption,
  MoveString,
  MoveVector,
  Uint8,
  Uint16,
  Uint32,
  Uint64,
  Uint128,
  Uint256,
} from "@aptos-labs/ts-sdk";
import {
  rawTransactionHelper,
  rawTransactionMultiAgentHelper,
  publishArgumentTestModule,
  PUBLISHER_ACCOUNT_PK,
  MULTI_SIGNER_SCRIPT_ARGUMENT_TEST,
  PUBLISHER_ACCOUNT_ADDRESS,
} from "./helper";
import { fundAccounts } from "../src";
import { ArgsTestSuite } from "../generated/";
import { TxArgsModule } from "../generated/args_test_suite";

// Upper bound values for uint8, uint16, uint64 and uint128
export const MAX_U8_NUMBER: Uint8 = 2 ** 8 - 1;
export const MAX_U16_NUMBER: Uint16 = 2 ** 16 - 1;
export const MAX_U32_NUMBER: Uint32 = 2 ** 32 - 1;
export const MAX_U64_BIG_INT: Uint64 = BigInt(2) ** BigInt(64) - BigInt(1);
export const MAX_U128_BIG_INT: Uint128 = BigInt(2) ** BigInt(128) - BigInt(1);
export const MAX_U256_BIG_INT: Uint256 = BigInt(2) ** BigInt(256) - BigInt(1);

jest.setTimeout(15000);

// This test uses lots of helper functions, explained here:
//  the `transactionArguments` array contains every possible argument type
//  the `rawTransactionHelper` and `rawTransactionMultiAgentHelper` functions are helpers to generate the transactions,
//    respectively for single signer transactions and for (multi signer & fee payer) transactions
// In any transaction with a `&signer` the move function asserts that the first argument is the senderAccount's address:
// `sender_address: address` or all of the `&signer` addresses: `signer_addresses: vector<address>`

describe("various transaction arguments", () => {
  const config = new AptosConfig({ network: Network.LOCAL });
  const aptos = new Aptos(config);
  const senderAccount = Account.fromPrivateKey({
    privateKey: new Ed25519PrivateKey(PUBLISHER_ACCOUNT_PK),
    legacy: false,
  });
  const secondarySignerAccounts = [Account.generate(), Account.generate(), Account.generate(), Account.generate()];
  const feePayerAccount = Account.generate();
  const moduleObjects: Array<AccountAddress> = [];
  let transactionArguments: Array<EntryFunctionArgumentTypes>;
  let simpleTransactionArguments: Array<SimpleEntryFunctionArgumentTypes>;
  let mixedTransactionArguments: Array<EntryFunctionArgumentTypes | SimpleEntryFunctionArgumentTypes>;
  const EXPECTED_VECTOR_U8 = new Uint8Array([0, 1, 2, MAX_U8_NUMBER - 2, MAX_U8_NUMBER - 1, MAX_U8_NUMBER]);
  const EXPECTED_VECTOR_STRING = ["expected_string", "abc", "def", "123", "456", "789"];

  beforeAll(async () => {
    await fundAccounts(aptos, [senderAccount, ...secondarySignerAccounts, feePayerAccount]);
    await publishArgumentTestModule(aptos, senderAccount);

    // when deploying, `init_module` creates 3 objects and stores them into the `SetupData` resource
    // within that resource is 3 fields: `empty_object_1`, `empty_object_2`, `empty_object_3`
    // we need to extract those objects and use them as arguments for the entry functions
    type SetupData = {
      empty_object_1: { inner: string };
      empty_object_2: { inner: string };
      empty_object_3: { inner: string };
    };

    const setupData = await aptos.getAccountResource<SetupData>({
      accountAddress: senderAccount.accountAddress.toString(),
      resourceType: `${senderAccount.accountAddress.toString()}::tx_args_module::SetupData`,
    });

    moduleObjects.push(AccountAddress.fromStringRelaxed(setupData.empty_object_1.inner));
    moduleObjects.push(AccountAddress.fromStringRelaxed(setupData.empty_object_2.inner));
    moduleObjects.push(AccountAddress.fromStringRelaxed(setupData.empty_object_3.inner));

    transactionArguments = [
      new Bool(true),
      new U8(1),
      new U16(2),
      new U32(3),
      new U64(4),
      new U128(5),
      new U256(6),
      senderAccount.accountAddress,
      new MoveString("expected_string"),
      moduleObjects[0],
      new MoveVector([]),
      MoveVector.Bool([true, false, true]),
      MoveVector.U8(EXPECTED_VECTOR_U8),
      MoveVector.U16([0, 1, 2, MAX_U16_NUMBER - 2, MAX_U16_NUMBER - 1, MAX_U16_NUMBER]),
      MoveVector.U32([0, 1, 2, MAX_U32_NUMBER - 2, MAX_U32_NUMBER - 1, MAX_U32_NUMBER]),
      MoveVector.U64([0, 1, 2, MAX_U64_BIG_INT - BigInt(2), MAX_U64_BIG_INT - BigInt(1), MAX_U64_BIG_INT]),
      MoveVector.U128([0, 1, 2, MAX_U128_BIG_INT - BigInt(2), MAX_U128_BIG_INT - BigInt(1), MAX_U128_BIG_INT]),
      MoveVector.U256([0, 1, 2, MAX_U256_BIG_INT - BigInt(2), MAX_U256_BIG_INT - BigInt(1), MAX_U256_BIG_INT]),
      new MoveVector([
        AccountAddress.fromStringRelaxed("0x0"),
        AccountAddress.fromStringRelaxed("0xabc"),
        AccountAddress.fromStringRelaxed("0xdef"),
        AccountAddress.fromStringRelaxed("0x123"),
        AccountAddress.fromStringRelaxed("0x456"),
        AccountAddress.fromStringRelaxed("0x789"),
      ]),
      MoveVector.MoveString(EXPECTED_VECTOR_STRING),
      new MoveVector(moduleObjects),
      new MoveOption(),
      new MoveOption(new Bool(true)),
      new MoveOption(new U8(1)),
      new MoveOption(new U16(2)),
      new MoveOption(new U32(3)),
      new MoveOption(new U64(4)),
      new MoveOption(new U128(5)),
      new MoveOption(new U256(6)),
      new MoveOption(senderAccount.accountAddress),
      new MoveOption(new MoveString("expected_string")),
      new MoveOption(moduleObjects[0]),
    ];

    simpleTransactionArguments = [
      true,
      1,
      2,
      3,
      4,
      5,
      6,
      senderAccount.accountAddress.toString(),
      "expected_string",
      moduleObjects[0].toString(),
      [],
      [true, false, true],
      [0, 1, 2, MAX_U8_NUMBER - 2, MAX_U8_NUMBER - 1, MAX_U8_NUMBER],
      [0, 1, 2, MAX_U16_NUMBER - 2, MAX_U16_NUMBER - 1, MAX_U16_NUMBER],
      [0, 1, 2, MAX_U32_NUMBER - 2, MAX_U32_NUMBER - 1, MAX_U32_NUMBER],
      [0, 1, 2, MAX_U64_BIG_INT - BigInt(2), MAX_U64_BIG_INT - BigInt(1), MAX_U64_BIG_INT.toString(10)],
      [0, 1, 2, MAX_U128_BIG_INT - BigInt(2), MAX_U128_BIG_INT - BigInt(1), MAX_U128_BIG_INT.toString(10)],
      [0, 1, 2, MAX_U256_BIG_INT - BigInt(2), MAX_U256_BIG_INT - BigInt(1), MAX_U256_BIG_INT.toString(10)],
      ["0x0", "0xabc", "0xdef", "0x123", "0x456", "0x789"],
      ["expected_string", "abc", "def", "123", "456", "789"],
      moduleObjects.map((obj) => obj.toString()),
      undefined,
      true,
      1,
      2,
      3,
      4,
      5,
      6,
      senderAccount.accountAddress.toString(),
      "expected_string",
      moduleObjects[0].toString(),
    ];

    // Mixes different types of number arguments, and parsed an unparsed arguments
    mixedTransactionArguments = [
      true,
      1,
      2,
      3,
      4n,
      BigInt(5),
      "6",
      senderAccount.accountAddress,
      "expected_string",
      moduleObjects[0],
      [],
      [true, false, true],
      [0, 1, 2, MAX_U8_NUMBER - 2, MAX_U8_NUMBER - 1, MAX_U8_NUMBER],
      [0, 1, 2, MAX_U16_NUMBER - 2, MAX_U16_NUMBER - 1, MAX_U16_NUMBER],
      [0, 1, 2, MAX_U32_NUMBER - 2, MAX_U32_NUMBER - 1, MAX_U32_NUMBER],
      [0, 1, 2, MAX_U64_BIG_INT - BigInt(2), MAX_U64_BIG_INT - BigInt(1), MAX_U64_BIG_INT.toString(10)],
      [0, 1, 2, MAX_U128_BIG_INT - BigInt(2), MAX_U128_BIG_INT - BigInt(1), MAX_U128_BIG_INT.toString(10)],
      [0, 1, 2, MAX_U256_BIG_INT - BigInt(2), MAX_U256_BIG_INT - BigInt(1), MAX_U256_BIG_INT.toString(10)],
      ["0x0", "0xabc", "0xdef", "0x123", "0x456", "0x789"],
      ["expected_string", "abc", "def", "123", "456", "789"],
      moduleObjects.map((obj) => obj.toString()),
      null,
      new MoveOption(new Bool(true)),
      1,
      2,
      3,
      4,
      5,
      6,
      senderAccount.accountAddress.toString(),
      "expected_string",
      moduleObjects[0].toString(),
    ];
  });

  describe("type tags", () => {
    describe("31 complex type tags", () => {
      const typeTags = [
        "bool",
        "u8",
        "u16",
        "u32",
        "u64",
        "u128",
        "u256",
        "address",
        "0x1::string::String",
        `0x1::object::Object<${PUBLISHER_ACCOUNT_ADDRESS}::tx_args_module::EmptyResource>`,
        "vector<bool>",
        "vector<u8>",
        "vector<u16>",
        "vector<u32>",
        "vector<u64>",
        "vector<u128>",
        "vector<u256>",
        "vector<address>",
        "vector<0x1::string::String>",
        `vector<0x1::object::Object<${PUBLISHER_ACCOUNT_ADDRESS}::tx_args_module::EmptyResource>>`,
        "0x1::option::Option<bool>",
        "0x1::option::Option<u8>",
        "0x1::option::Option<u16>",
        "0x1::option::Option<u32>",
        "0x1::option::Option<u64>",
        "0x1::option::Option<u128>",
        "0x1::option::Option<u256>",
        "0x1::option::Option<address>",
        "0x1::option::Option<0x1::string::String>",
        `0x1::option::Option<0x1::object::Object<${PUBLISHER_ACCOUNT_ADDRESS}::tx_args_module::EmptyResource>>`,
        `vector<vector<0x1::option::Option<vector<0x1::option::Option<0x1::object::Object<${PUBLISHER_ACCOUNT_ADDRESS}::tx_args_module::EmptyResource>>>>>>`,
      ].map((s) => parseTypeTag(s));
      describe("create builder and submit", () => {
        it("successfully submits a transaction", async () => {
          const builder = await TxArgsModule.TypeTags.builder(aptos.config, senderAccount.accountAddress, typeTags);

          const response = await builder.submit({
            primarySigner: senderAccount,
          });

          expect(response.success).toBe(true);
        });

        it("successfully submits a transaction with a fee payer", async () => {
          const builder = await TxArgsModule.TypeTags.builderWithFeePayer(
            aptos.config,
            senderAccount.accountAddress,
            typeTags,
            feePayerAccount.accountAddress,
          );
          const response = await builder.submit({
            primarySigner: senderAccount,
            feePayer: feePayerAccount,
          });

          expect(response.success).toBe(true);
        });
      });

      describe("chaining builder + submit", () => {
        it("chains builder and submit", async () => {
          const response = await TxArgsModule.TypeTags.submit(aptos.config, senderAccount, typeTags);
          expect(response.success).toBe(true);
        });

        it("chains builder and submit with fee payer", async () => {
          const response = await TxArgsModule.TypeTags.submitWithFeePayer(
            aptos.config,
            senderAccount,
            typeTags,
            feePayerAccount,
          );
          expect(response.success).toBe(true);
        });
      });
    });
  });

  describe.skip("single signer entry fns, all arguments except `&signer`, both public and private entry functions", () => {
    describe("sender is ed25519", () => {
      it("successfully submits a public entry fn with all argument types except `&signer`", async () => {
        const response = await rawTransactionHelper(aptos, senderAccount, "public_arguments", [], transactionArguments);
        expect(response.success).toBe(true);
      });

      it("successfully submits a private entry fn with all argument types except `&signer`", async () => {
        const response = await rawTransactionHelper(
          aptos,
          senderAccount,
          "private_arguments",
          [],
          transactionArguments,
        );
        expect(response.success).toBe(true);
      });

      it("simple inputs successfully submits a public entry fn with all argument types except `&signer`", async () => {
        const response = await rawTransactionHelper(
          aptos,
          senderAccount,
          "public_arguments",
          [],
          simpleTransactionArguments,
        );
        expect(response.success).toBe(true);
      });

      it("simple inputs successfully submits a private entry fn with all argument types except `&signer`", async () => {
        const response = await rawTransactionHelper(
          aptos,
          senderAccount,
          "private_arguments",
          [],
          simpleTransactionArguments,
        );
        expect(response.success).toBe(true);
      });

      it("mixed inputs successfully submits a public entry fn with all argument types except `&signer`", async () => {
        const response = await rawTransactionHelper(
          aptos,
          senderAccount,
          "public_arguments",
          [],
          mixedTransactionArguments,
        );
        expect(response.success).toBe(true);
      });

      it("mixed inputs successfully submits a private entry fn with all argument types except `&signer`", async () => {
        const response = await rawTransactionHelper(
          aptos,
          senderAccount,
          "private_arguments",
          [],
          mixedTransactionArguments,
        );
        expect(response.success).toBe(true);
      });
    });
  });

  // only public entry functions- shouldn't need to test private again
  describe.skip("single signer transactions with all entry function arguments", () => {
    it("successfully submits a single signer transaction with all argument types", async () => {
      const response = await rawTransactionHelper(aptos, senderAccount, "public_arguments", [], transactionArguments);
      expect(response.success).toBe(true);
    });

    it("simple inputs successfully submits a single signer transaction with all argument types", async () => {
      const response = await rawTransactionHelper(
        aptos,
        senderAccount,
        "public_arguments",
        [],
        simpleTransactionArguments,
      );
      expect(response.success).toBe(true);
    });
  });

  // only public entry functions- shouldn't need to test private again
  describe.skip("multi signer transaction with all entry function arguments", () => {
    it("successfully submits a multi signer transaction with all argument types", async () => {
      const secondarySignerAddresses = secondarySignerAccounts.map((account) => account.accountAddress);
      const response = await rawTransactionMultiAgentHelper(
        aptos,
        senderAccount,
        "public_arguments_multiple_signers",
        [],
        [
          new MoveVector<AccountAddress>([senderAccount.accountAddress, ...secondarySignerAddresses]),
          ...transactionArguments,
        ],
        secondarySignerAccounts,
      );
      expect(response.success).toBe(true);
      const responseSignature = response.signature as TransactionMultiAgentSignature;
      const secondarySignerAddressesParsed = responseSignature.secondary_signer_addresses.map((address) =>
        AccountAddress.fromStringRelaxed(address),
      );
      expect(secondarySignerAddressesParsed.map((s) => s.toString())).toEqual(
        secondarySignerAddresses.map((address) => address.toString()),
      );
      expect((responseSignature as any).fee_payer_address).toBeUndefined();
    });

    it("simple inputs successfully submits a multi signer transaction with all argument types", async () => {
      const secondarySignerAddresses = secondarySignerAccounts.map((account) => account.accountAddress);
      const response = await rawTransactionMultiAgentHelper(
        aptos,
        senderAccount,
        "public_arguments_multiple_signers",
        [],
        [
          [senderAccount.accountAddress.toString(), ...secondarySignerAddresses.map((address) => address.toString())],
          ...simpleTransactionArguments,
        ],
        secondarySignerAccounts,
      );
      expect(response.success).toBe(true);
      const responseSignature = response.signature as TransactionMultiAgentSignature;
      const secondarySignerAddressesParsed = responseSignature.secondary_signer_addresses.map((address) =>
        AccountAddress.fromStringRelaxed(address),
      );
      expect(secondarySignerAddressesParsed.map((s) => s.toString())).toEqual(
        secondarySignerAddresses.map((address) => address.toString()),
      );
      expect((responseSignature as any).fee_payer_address).toBeUndefined();
    });
  });

  describe.skip("fee payer transactions with various numbers of signers", () => {
    it("successfully submits a sponsored transaction with all argument types", async () => {
      const response = await rawTransactionMultiAgentHelper(
        aptos,
        senderAccount,
        "public_arguments",
        [],
        transactionArguments,
        [], // secondary signers
        feePayerAccount,
      );
      expect(response.success).toBe(true);
      const responseSignature = response.signature as TransactionFeePayerSignature;
      expect(responseSignature.secondary_signer_addresses.length).toEqual(0);
      expect(AccountAddress.fromStringRelaxed(responseSignature.fee_payer_address).toString()).toEqual(
        feePayerAccount.accountAddress.toString(),
      );
    });

    it("successfully submits a sponsored multi signer transaction with all argument types", async () => {
      const secondarySignerAddresses = secondarySignerAccounts.map((account) => account.accountAddress);
      const response = await rawTransactionMultiAgentHelper(
        aptos,
        senderAccount,
        "public_arguments_multiple_signers",
        [],
        [
          new MoveVector<AccountAddress>([senderAccount.accountAddress, ...secondarySignerAddresses]),
          ...transactionArguments,
        ],
        secondarySignerAccounts,
        feePayerAccount,
      );
      expect(response.success).toBe(true);
      const responseSignature = response.signature as TransactionFeePayerSignature;
      const secondarySignerAddressesParsed = responseSignature.secondary_signer_addresses.map((address) =>
        AccountAddress.fromStringRelaxed(address),
      );
      expect(secondarySignerAddressesParsed.map((s) => s.toString())).toEqual(
        secondarySignerAddresses.map((address) => address.toString()),
      );
      expect(AccountAddress.fromStringRelaxed(responseSignature.fee_payer_address).toString()).toEqual(
        feePayerAccount.accountAddress.toString(),
      );
    });

    it("simple inputs successfully submits a sponsored transaction with all argument types", async () => {
      const response = await rawTransactionMultiAgentHelper(
        aptos,
        senderAccount,
        "public_arguments",
        [],
        transactionArguments,
        [], // secondary signers
        feePayerAccount,
      );
      expect(response.success).toBe(true);
      const responseSignature = response.signature as TransactionFeePayerSignature;
      expect(responseSignature.secondary_signer_addresses.length).toEqual(0);
      expect(AccountAddress.fromStringRelaxed(responseSignature.fee_payer_address).toString()).toEqual(
        feePayerAccount.accountAddress.toString(),
      );
    });

    it("simple inputs successfully submits a sponsored multi signer transaction with all argument types", async () => {
      const secondarySignerAddresses = secondarySignerAccounts.map((account) => account.accountAddress);
      const response = await rawTransactionMultiAgentHelper(
        aptos,
        senderAccount,
        "public_arguments_multiple_signers",
        [],
        [
          [senderAccount.accountAddress.toString(), ...secondarySignerAddresses.map((address) => address.toString())],
          ...simpleTransactionArguments,
        ],
        secondarySignerAccounts,
        feePayerAccount,
      );
      expect(response.success).toBe(true);
      const responseSignature = response.signature as TransactionFeePayerSignature;
      const secondarySignerAddressesParsed = responseSignature.secondary_signer_addresses.map((address) =>
        AccountAddress.fromStringRelaxed(address),
      );
      expect(secondarySignerAddressesParsed.map((s) => s.toString())).toEqual(
        secondarySignerAddresses.map((address) => address.toString()),
      );
      expect(AccountAddress.fromStringRelaxed(responseSignature.fee_payer_address).toString()).toEqual(
        feePayerAccount.accountAddress.toString(),
      );
    });
  });

  describe.skip("script transactions", () => {
    it("successfully submits a script transaction with all argument types", async () => {
      const rawTransaction = await aptos.generateTransaction({
        sender: senderAccount.accountAddress.toString(),
        data: {
          bytecode: MULTI_SIGNER_SCRIPT_ARGUMENT_TEST,
          functionArguments: [
            senderAccount.accountAddress,
            ...secondarySignerAccounts.map((account) => account.accountAddress),
            new Bool(true),
            new U8(1),
            new U16(2),
            new U32(3),
            new U64(4),
            new U128(5),
            new U256(6),
            senderAccount.accountAddress,
            new MoveString("expected_string"),
            moduleObjects[0],
            MoveVector.U8([0, 1, 2, MAX_U8_NUMBER - 2, MAX_U8_NUMBER - 1, MAX_U8_NUMBER]),
          ],
        },
        secondarySignerAddresses: secondarySignerAccounts.map((account) => account.accountAddress.toString()),
      });
      const senderAuthenticator = await aptos.signTransaction({ signer: senderAccount, transaction: rawTransaction });
      const secondaryAuthenticators = secondarySignerAccounts.map((account) =>
        aptos.signTransaction({
          signer: account,
          transaction: rawTransaction,
        }),
      );
      const transactionResponse = await aptos.submitTransaction({
        transaction: rawTransaction,
        senderAuthenticator,
        additionalSignersAuthenticators: secondaryAuthenticators,
      });
      const response = (await aptos.waitForTransaction({
        transactionHash: transactionResponse.hash,
      })) as UserTransactionResponse;
      expect(response.success).toBe(true);
      expect((response.signature as TransactionMultiAgentSignature).type).toBe("multi_agent_signature");
      expect(response.payload.type).toBe("script_payload");
    });
  });

  describe.skip("nested, complex arguments", () => {
    it("successfully submits a function with very complex arguments", async () => {
      const optionVector = new MoveOption(MoveVector.MoveString(EXPECTED_VECTOR_STRING));
      const deeplyNested3 = new MoveVector([optionVector, optionVector, optionVector]);
      const deeplyNested4 = new MoveVector([deeplyNested3, deeplyNested3, deeplyNested3]);

      const response = await rawTransactionMultiAgentHelper(
        aptos,
        senderAccount,
        "complex_arguments",
        [],
        [
          new MoveVector([
            MoveVector.U8(EXPECTED_VECTOR_U8),
            MoveVector.U8(EXPECTED_VECTOR_U8),
            MoveVector.U8(EXPECTED_VECTOR_U8),
          ]),
          new MoveVector([
            MoveVector.MoveString(EXPECTED_VECTOR_STRING),
            MoveVector.MoveString(EXPECTED_VECTOR_STRING),
            MoveVector.MoveString(EXPECTED_VECTOR_STRING),
          ]),
          deeplyNested3,
          deeplyNested4,
        ],
        secondarySignerAccounts,
        feePayerAccount,
      );
      expect(response.success).toBe(true);
    });
  });

  describe.skip("view functions", () => {
    type MoveStructLayoutObject = {
      inner: string;
    };

    // To normalize the addresses, since the first Object address starts with a 0, the JSON response doesn't include it
    // but ours does.
    const normalizer = (vectorOfObjects: Array<MoveStructLayoutObject>) => {
      return vectorOfObjects.map((obj: any) => {
        return { inner: AccountAddress.fromRelaxed(obj.inner).toString() };
      });
    };

    // Note that this returns:
    //   (
    //      vector<vector<u8>>,
    //      vector<vector<Object<EmptyResource>>>,
    //      vector<Option<vector<Object<EmptyResource>>>>,
    //      vector<vector<Option<vector<Object<EmptyResource>>>>>,
    //   )
    it("correctly expects the view function complex outputs", async () => {
      const viewFunctionResponse = (await aptos.view({
        payload: {
          function: `${senderAccount.accountAddress.toString()}::tx_args_module::view_complex_outputs`,
          functionArguments: [],
          typeArguments: [],
        },
      })) as any;
      expect(viewFunctionResponse.length == 4).toBe(true);

      // serialize without length
      const expectedVectorU8HexString = new FixedBytes(EXPECTED_VECTOR_U8).bcsToHex().toString();
      expect(viewFunctionResponse[0]).toEqual([
        expectedVectorU8HexString,
        expectedVectorU8HexString,
        expectedVectorU8HexString,
      ]);

      // We need each obj to be in the format: `{ inner: "0x..." }`
      const vectorObjectEmptyResource = moduleObjects.map((obj) => {
        return { inner: obj.toString() };
      });
      // We must normalize the object addresses in the response
      expect(viewFunctionResponse[1].length == 3).toBe(true);
      expect(normalizer(viewFunctionResponse[1][0])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[1][1])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[1][2])).toEqual(vectorObjectEmptyResource);

      expect(viewFunctionResponse[2].length == 3).toBe(true);
      expect(viewFunctionResponse[2][0].vec.length == 1).toBe(true);
      expect(normalizer(viewFunctionResponse[2][0].vec[0])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[2][1].vec[0])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[2][2].vec[0])).toEqual(vectorObjectEmptyResource);

      expect(viewFunctionResponse[3].length == 3).toBe(true);
      expect(viewFunctionResponse[3][0].length == 3).toBe(true);
      expect(viewFunctionResponse[3][0].length == 3).toBe(true);
      expect(viewFunctionResponse[3][0][0].vec.length == 1).toBe(true);
      expect(normalizer(viewFunctionResponse[3][0][0].vec[0])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[3][0][1].vec[0])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[3][0][2].vec[0])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[3][1][0].vec[0])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[3][1][1].vec[0])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[3][1][2].vec[0])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[3][2][0].vec[0])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[3][2][1].vec[0])).toEqual(vectorObjectEmptyResource);
      expect(normalizer(viewFunctionResponse[3][2][2].vec[0])).toEqual(vectorObjectEmptyResource);
    });

    // Currently fails.
    it.skip("successfully submits a view function with all argument types", async () => {
      const viewFunctionArguments = [
        true,
        1,
        2,
        3,
        4n.toString(),
        5n.toString(),
        6n.toString(),
        senderAccount.accountAddress.toString(),
        "expected_string",
        moduleObjects[0].toString(),
        Hex.fromHexInput(new Uint8Array([])).toString(),
        [true, false, true],
        Hex.fromHexInput(new Uint8Array([0, 1, 2, MAX_U8_NUMBER - 2, MAX_U8_NUMBER - 1, MAX_U8_NUMBER])).toString(),
        [0, 1, 2, MAX_U16_NUMBER - 2, MAX_U16_NUMBER - 1, MAX_U16_NUMBER],
        [0, 1, 2, MAX_U32_NUMBER - 2, MAX_U32_NUMBER - 1, MAX_U32_NUMBER],
        [0, 1, 2, MAX_U64_BIG_INT - BigInt(2), MAX_U64_BIG_INT - BigInt(1), MAX_U64_BIG_INT].map((n) => n.toString()),
        [0, 1, 2, MAX_U128_BIG_INT - BigInt(2), MAX_U128_BIG_INT - BigInt(1), MAX_U128_BIG_INT].map((n) =>
          n.toString(),
        ),
        [0, 1, 2, MAX_U256_BIG_INT - BigInt(2), MAX_U256_BIG_INT - BigInt(1), MAX_U256_BIG_INT].map((n) =>
          n.toString(),
        ),
        ["0x0", "0xabc", "0xdef", "0x123", "0x456", "0x789"],
        ["expected_string", "abc", "def", "123", "456", "789"],
        moduleObjects.map((obj) => {
          return { inner: obj.toString() };
        }),
        { vec: "0x" },
        { vec: [true] },
        { vec: MoveOption.U8(1).bcsToHex().toString() },
        // TODO: Fix the below. they currently do not work.
        { vec: MoveOption.U16(2).bcsToHex().toString() },
        { vec: MoveOption.U32(3).bcsToHex().toString() },
        { vec: MoveOption.U64(4).bcsToHex().toString() },
        { vec: MoveOption.U128(5).bcsToHex().toString() },
        { vec: MoveOption.U256(6).bcsToHex().toString() },
        [senderAccount.accountAddress.toString()],
        ["expected_string"],
        [moduleObjects[0].toString()],
      ];

      // Currently does not work. Fails at the 24th tx arg as noted in the arg array above.
      const viewFunctionResponse = await aptos.view({
        payload: {
          function: `${senderAccount.accountAddress.toString()}::tx_args_module::view_all_arguments`,
          functionArguments: viewFunctionArguments,
          typeArguments: [],
        },
      });
      console.log(viewFunctionResponse);
    });
  });
});
