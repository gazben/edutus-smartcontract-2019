pragma solidity >0.5.5;

contract AuctionHouse {
    uint256 auctionCount = 0;
    Auction[] public auctions;

    function createAuction(
        string memory _title,
        string memory _description
        ) public {
          Auction newAuction = new Auction(msg.sender, _title, _description);
          auctions.push(newAuction);
          auctionCount++;
        }
}

contract Auction {
    string public title;
    string public description;
    address payable owner;
    uint256 public highestBid;
    address payable highestBidOwner;

    enum State{Listed, Started, Finished}
    State public state;

    constructor(
        address payable _owner,
        string memory _title,
        string memory _description
        ) public {
            owner = _owner;
            title = _title;
            description = _description;
            highestBid = 0;
            state = State.Listed;
    }

    function start() public {
        require(state == State.Listed, "Auction state has to be Listed!");
        require(owner == msg.sender, "Only the owner can start the auction!");
        state = State.Started;
    }

    function close() public {
        require(state == State.Started, "The auction has to be started!");
        require(owner == msg.sender, "Only the owner can close the auction!");
        // TODO: time expired or max bid reached
        
        owner.transfer(highestBid);
        
        state = State.Finished;
        owner = highestBidOwner;
    }

    function bid() public payable {
        require(msg.sender != owner, "You cannot bid on your own auction!");
        require(msg.value > highestBid, "Your bid needs to be higher than the current!");
        require(msg.sender != highestBidOwner, "YOu cannot bid on top of your own!");
        require(state == State.Started, "You can only bid on Started auctions!");

        highestBidOwner.transfer(highestBid);

        highestBid = msg.value;
        highestBidOwner = msg.sender;
    }

    function finalBid() public view returns(uint256) {
        require(state == State.Finished, "Auction needs to be in Finished state!");

        return highestBid;
    }
}