module.exports = {
    env: {
      browser: true,
      es2021: true,
      node: true,
    },
    ignorePatterns: ["dist/**", "node_modules/**"],
    extends: ["airbnb-base", "airbnb-typescript/base", "prettier"],
    parser: "@typescript-eslint/parser",
    parserOptions: {
      tsconfigRootDir: __dirname,
      project: ["tsconfig.json"],
      ecmaVersion: "latest",
      sourceType: "module",
    },
    plugins: ["@typescript-eslint", "unused-imports"],
    rules: {
      quotes: ["error", "double"],
      "max-len": ["error", 100],
      "import/extensions": ["error", "never"],
      "import/no-commonjs": ["error", { allowRequire: false, allowPrimitiveModules: false }],
      "import/no-extraneous-dependencies": [
        "error",
        {
          devDependencies: true,
          optionalDependencies: true,
          peerDependencies: true,
        },
      ],
      "@typescript-eslint/member-delimiter-style": ["error", {
        multiline: {
          delimiter: "semi",
          requireLast: true,
        },
        singleline: {
          delimiter: "semi",
          requireLast: false,
        },
      }],
      "import/no-useless-path-segments": ["error", { noUselessIndex: true }],
      "max-classes-per-file": ["error", 10],
      "import/prefer-default-export": "off",
      "object-curly-newline": "off",
      // Replacing airbnb rule with following, to re-enable "ForOfStatement"
      "no-restricted-syntax": ["error", "ForInStatement", "LabeledStatement", "WithStatement"],
      "no-use-before-define": "off",
      "@typescript-eslint/no-use-before-define": ["error", { functions: false, classes: false }],
      "no-unused-vars": "off",
      "@typescript-eslint/no-unused-vars": [
        "warn",
        { argsIgnorePattern: "^_", destructuredArrayIgnorePattern: "^_" },
      ],
      "unused-imports/no-unused-imports": "error",
      "@typescript-eslint/consistent-type-imports": [
        "error",
        { prefer: "type-imports", fixStyle: "inline-type-imports" },
      ],
    },
    settings: {
      "import/resolver": {
        node: {
          extensions: [".js", ".jsx", ".ts", ".tsx"],
        },
      },
    },
  };
  