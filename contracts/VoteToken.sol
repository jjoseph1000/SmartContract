pragma solidity ^0.4.11;

contract VoteToken {
    
    uint public constant _totalSupply = 472831000;

    string public constant symbol = "AMR";
    string public constant name = "American Airlines Token";   
    uint8 public constant decimals = 0;
    address[] Addresses;
    
    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed from, address indexed to, uint256 value);

    mapping(address => uint256) balances;    
    mapping(address => mapping(address => uint256)) allowed;

    function VoteToken() {
        balances[msg.sender] = _totalSupply;        
        Addresses.push(msg.sender); 
    }

    function totalAddresses() returns (uint256 totalAddresses) {
        return Addresses.length;
    }

    function balanceByIndex(uint256 index) returns (address pubAddress, uint256 balance) {
        address selAddress = Addresses[index];
        return (selAddress, balanceOf(selAddress));
    }

     function totalSupply() constant returns (uint256 totalSupply) {
        return _totalSupply;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        require(
            balances[msg.sender] >= _value &&
            _value > 0
        );
        balances[msg.sender] -= _value;

        if (balances[_to] == 0)
        {
            Addresses.push(_to);
        }

        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferfrom(address _from, address _to, uint256 _value) returns (bool success) {
        require(
            allowed[_from][msg.sender] >= _value && 
            balances[_from] >= _value
            && _value > 0
        );
        balances[_from] -= _value;

        if (balances[_to] == 0)
        {
            Addresses.push(_to);
        }

        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

}