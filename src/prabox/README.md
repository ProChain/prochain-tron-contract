# Prabox for TRON

## 合约部署顺序

1. 部署Black.sol，取得合约地址A
2. 部署User.sol，取得合约地址B
3. 部署Candy.sol，取得合约地址C
4. 部署PraboxBase.sol，取得合约地址D
5. 调用PraboxBase合约的setBlackContract(A)、setUserContract(B)、setCandyContract(C)，设置相应地址
6. 调用User合约、Candy合约的setPraboxAddress(D)，设置PraboxBase地址，用于调用鉴权

## 合约接口

1. `领糖果`
   - PraboxBase合约的click()

2. `糖果管理`
   - Candy合约：addCandy()
   - delCandy()
   - getCandy()

3. `用户管理`
   - User合约：auth()
   - delUser()
   - getUser()

4. `黑名单`
   - Black合约：validAddress()
   - addblack()
   - delblack()

5. `权限管理`
   - setAdminA()
   - setAdminB()
   - pause()
   - unpause()