# prochain-tron-contract

## 参考

- Solidity 安全：已知攻击方法和常见防御模式综合列表 https://github.com/slowmist/Knowledge-Base/blob/master/solidity-security-comprehensive-list-of-known-attack-vectors-and-common-anti-patterns-chinese.md

- VS Code 安装solidity插件：
  - 下载solidity插件 https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity
  
  - 使用严格版语法检查
    ```
        在Code->设置->用户设置里，加入：
        "solidity.linter": "solhint",
        "solidity.solhintRules": {
            "avoid-sha3": "warn"
        }
    ```

  - 修改编译器版本
    ```
        在Code->设置->用户设置里，加入："solidity.compileUsingRemoteVersion" : "v0.4.23+commit.124ca40d"
        默认是 "latest"
    ```

- shasta测试网：https://shasta.tronscan.org/