// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "./StandardToken.sol";
import "./2_Owner.sol";

contract MyAwesomeToken is StandardToken, Owner {
    using SafeMath for uint256;    
    string constant public name = "My Awesome Token";
    string constant public symbol = "MAT";
    uint constant public decimals = 18;
    uint public hardcap = 1000;
    uint MATprice = 0.001 ether;

    event Mint(address indexed to, uint256 amount);
    
    event MintFinished();

    bool public mintingFinished = false;

    modifier mintingInProcess() {
        require(!mintingFinished);
        _;
    }

    function _mint(uint256 _amount) internal returns (uint) {
        uint refund = 0;
        bool stopICO = false;

        if (totalSupply.add(_amount) >= hardcap)
        {
            refund = _amount.sub(hardcap.sub(totalSupply));
            _amount = hardcap.sub(totalSupply);
            stopICO = true;
        }

        if (_amount > 0)
        {
            totalSupply = totalSupply.add(_amount);
            balances[msg.sender] = balances[msg.sender].add(_amount);
            emit Mint(msg.sender, _amount);
        }

        if (stopICO)
        {
            _stopMinting();
        }

        return refund;
    }

    // Transfer 10 % to owner of smart contract
    function _getReward() internal {
        uint reward = totalSupply.div(10);
        address _owner = getOwner();
        balances[_owner] = balances[_owner].add(reward);
    }

    /*
        Stop minting tokens because of owner's command or hardcap is reached.
    */
    function _stopMinting() internal returns (bool) {
        mintingFinished = true;
        _getReward();
        emit MintFinished();
        return true;
    }

    /*
        Forcing stop minting tokens.
    */
    function finishMinting() public isOwner mintingInProcess returns (bool) {
        _stopMinting();
        return true;
    }

    function buyTokens() public payable mintingInProcess {
        uint tokens = (msg.value).div(MATprice);
        uint refund = (msg.value).sub( (tokens.mul(MATprice)) );
        uint refundTokens = _mint(tokens);
        refund = refund.add( (refundTokens.mul(MATprice)) );

        if (refund > 0)
        {
            payable(msg.sender).transfer(refund);
        }

        address contractOwner = getOwner();
        payable(contractOwner).transfer(address(this).balance);
    }


}

