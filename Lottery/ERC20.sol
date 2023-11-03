// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "./SafeMath.sol";

interface IERC20{
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns(uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20Basic is IERC20{

    string public constant name = "TestERC20";
    string public constant symbol = "ERC20";
    uint8 public constant decimals = 18;


    using SafeMath for uint256;

    address owner;
    mapping (address => uint) balances;
    mapping (address => mapping(address => uint)) allowed;
    uint256 totalSupply_;

    modifier onlyOwner(){
        require(owner == msg.sender,"Must be Owner");
        _;
    }

    constructor (uint256 initialSupply){
        owner = msg.sender;
        totalSupply_ = initialSupply;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }

    function balanceOf(address _tokenOwner) public override view returns(uint256){
        return balances[_tokenOwner];
    }

    function allowance(address _owner, address _delegate) public override view returns(uint256){
        return allowed[_owner][_delegate];
    }

    function transfer(address _recipient, uint256 _numTokens) public override returns (bool){
        require(_numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(_numTokens);
        balances[_recipient] = balances[_recipient].add(_numTokens);
        emit Transfer(msg.sender,_recipient,_numTokens);
        return true;
    }

    function approve(address _delegate, uint256 _numTokens) public override returns (bool){
        require(_numTokens <= balances[msg.sender]);
        allowed[msg.sender][_delegate] = _numTokens;
        emit Approval(msg.sender, _delegate, _numTokens);
        return true;
    }

    function transferFrom(address _owner, address _receiver, uint256 _numTokens) public override returns (bool){
        require(_numTokens <= balances[_owner]);
        balances[_owner] = balances[_owner].sub(_numTokens);
        balances[_receiver] = balances[_receiver].add(_numTokens);
        emit Transfer(_owner,_receiver,_numTokens);
        return true;
    }

    //only owner functions
    function renounceOwnership() public onlyOwner{
        owner = address(0);
    }


    function increaseTotalSupply(uint _newTokensAmount) public onlyOwner{
        totalSupply_ +=  _newTokensAmount;
        balances[msg.sender] += _newTokensAmount;
    }


}