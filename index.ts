#!/usr/bin/env node
/* eslint-disable no-console */
import { lightBlue } from "kolorist";
import { Aptos, AptosConfig, AccountAddress } from "@aptos-labs/ts-sdk";
import prompts from "prompts";
import { CodeGenerator, getCodeGenConfig } from "./src";
import { userInputs } from "./src/workflow.js";

const headerText = `
 _      _                            _         _   
| |__  | | _   _   ___  _ __   _ __ (_) _ __  | |_ 
| '_ \\ | || | | | / _ \\| '_ \\ | '__|| || '_ \\ | __|
| |_) || || |_| ||  __/| |_) || |   | || | | || |_ 
|_.__/ |_| \\__,_| \\___|| .__/ |_|   |_||_| |_| \\__|
                       |_|                          
`
  .split("\n")
  .map((line) =>
    [...line]
      .map((char, i) => {
        if (i < 23 && !char.match(/\s/)) {
          return lightBlue(char);
        }
        return char;
      })
      .join("")
  )
  .join("\n");

console.log(headerText);
console.log();
console.log("💻 Welcome to the Aptos Blueprint wizard 🔮");

async function main() {
  prompts.inject([
    "config.yaml",
    [
      // AccountAddress.ONE,
      // AccountAddress.THREE,
      // AccountAddress.FOUR,
      // AccountAddress.from("0x4bab58978ec1b1bef032eeb285ad47a6a9b997d646c19b598c35f46b26ff9ece"),
      // AccountAddress.from("0xf000d910b99722d201c6cf88eb7d1112b43475b9765b118f289b5d65d919000d"),
      AccountAddress.from("0x2222e4c4788e34e21bacad364855f5e648c19f4643f20f22f507334d041c2222"),
    ],
    "",
    "testnet",
  ]);
  const selections = await userInputs();
  const codeGeneratorConfig = getCodeGenConfig(selections.configPath);
  const codeGenerator = new CodeGenerator(codeGeneratorConfig);
  const aptosConfig = new AptosConfig({ network: selections.network });
  const aptos = new Aptos(aptosConfig);
  await codeGenerator.generateCodeForModules(aptos, [
    ...selections.namedModules,
    ...selections.additionalModules,
  ]);
}

main().catch((e) => {
  console.error(e);
});
