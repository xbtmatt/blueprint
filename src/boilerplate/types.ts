// Copyright © Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

import { AccountAddress, AccountAddressInput, TypeTag } from "@aptos-labs/ts-sdk";

export type Option<T> = [T] | [];

export type ObjectAddress = AccountAddressInput;

export type Uint8 = number;
export type Uint16 = number;
export type Uint32 = number;
export type Uint64 = number | bigint;
export type Uint128 = number | bigint;
export type Uint256 = number | bigint;
export type AnyNumber = number | bigint;

export type InputTypes =
  | boolean
  | Uint8
  | Uint16
  | Uint32
  | Uint64
  | Uint128
  | Uint256
  | AccountAddressInput
  | string
  | ObjectAddress
  | Array<InputTypes>;
export type TypeTagInput = string | TypeTag;

export type MoveObject = AccountAddress;

// for clarity in JSON view function return response types
export type Uint64String = string;
export type Uint128String = string;
export type Uint256String = string;
export type AccountAddressString = string;
export type ObjectAddressStruct = {
  inner: string;
};
