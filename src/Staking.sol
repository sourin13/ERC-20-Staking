// SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

interface IERC20 {
    function transferFrom( // Our staking contract needs to tell the token contract : "Take 100 from Alice and send them to me"
        address from,
        address to,
        uint256 amount
    )
        external
        returns (bool);

    function transfer( //Later when Alice withdraws,the staking contract needs to pay her back"
        address to,
        uint256 amount
    )
        external
        returns (bool);
}

contract Staking {
    IERC20 public stakingToken;

    uint256 public rewardRate = 10;

    struct Stake {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => Stake) public stakes;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount, uint256 reward);

    constructor(address _stakingToken) {
        stakingToken = IERC20(_stakingToken);
    }

    function fundRewards(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");

        stakingToken.transferFrom(msg.sender, address(this), amount);
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");

        stakingToken.transferFrom(msg.sender, address(this), amount);

        stakes[msg.sender].amount += amount;
        stakes[msg.sender].startTime = block.timestamp;
        emit Staked(msg.sender, amount);
    }

    function calculateReward(address user) public view returns (uint256) {
        Stake memory userStake = stakes[user];

        if (userStake.amount == 0) {
            return 0;
        }

        uint256 duration = block.timestamp - userStake.startTime;
        uint256 reward = userStake.amount * rewardRate * duration / 365 days / 100;

        return reward;
    }

    function withdraw() public {
        Stake memory userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No stake");

        uint256 reward = calculateReward(msg.sender);

        uint256 totalAmount = userStake.amount + reward;

        delete stakes[msg.sender];

        stakingToken.transfer(msg.sender, totalAmount);

        emit Withdrawn(msg.sender, userStake.amount, reward);
    }
}

