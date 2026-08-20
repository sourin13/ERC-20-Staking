//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

contract MyToken{
    string public name="MyToken";
    string public symbol="MTK";
    uint8 public decimals=18;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address =>mapping(address =>uint256)) public allowance;

    constructor(){
    totalSupply=1000000*10**decimals;
    balanceOf[msg.sender]=totalSupply;
}
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
    );

    function transfer(address to,uint256 amount) public returns(bool){
        require(balanceOf[msg.sender]>=amount, "Insufficient Balance");
        balanceOf[msg.sender] -=amount;
        balanceOf[to] +=amount;

        emit Transfer(msg.sender,to,amount);
        return true;
    }
    function approve(address spender,uint256 amount) public returns (bool){
        allowance[msg.sender][spender]=amount;

        emit Approval(msg.sender,spender,amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount) public returns (bool){
            require(
                balanceOf[from]>=amount, "Insufficient Balance"
            );
            require(
                allowance[from][msg.sender]>=amount,"Insufficient Allowance"
            );

            balanceOf[from] -=amount;
            balanceOf[to] +=amount;

            allowance[from][msg.sender] -=amount;

            emit Transfer(from,to,amount);
            return true;
        
        
        }
    

}