pragma solidity ^0.4.11;

contract VoteSession {
    bytes32[] _questions;
    bool[] _questionIsActive;
    address _owner;

    mapping(address => bytes32) _voteSelections;
    mapping(address => uint) _hasVoted;
    address[] _voteSelectionsAddresses;

    function VoteSession() {
        _owner = msg.sender;
    }

    function Vote(string selectedAnswers) returns (bool Result) {        
        if (_hasVoted[msg.sender] == 0) {
            _hasVoted[msg.sender] = 1;
            _voteSelectionsAddresses.push(msg.sender);
        }

        _voteSelections[msg.sender] = stringToBytes32(selectedAnswers);

        return true;
    }

    function totalVoters() returns (uint256 totalVoters) {
        return _voteSelectionsAddresses.length;
    }

    function getVoteAnswers() returns (string voteAnswers) {
        return bytes32ToString(_voteSelections[msg.sender]);
    }

    function getVoteAnswersByIndex(uint256 voterIndex) returns (address voter, string voteAnswers) {
        address selectedAddress = _voteSelectionsAddresses[voterIndex];
        return (selectedAddress, bytes32ToString(_voteSelections[selectedAddress]));
    }


    function addQuestion(string question) returns (bool added) {
        require(msg.sender == _owner && _voteSelectionsAddresses.length == 0); 
                
        _questions.push(stringToBytes32(question));
        _questionIsActive.push(true);

        return true;
    }

    function removeQuestionAtIndex(uint questionIndex) returns (bool removed) {
        require(msg.sender == _owner && _voteSelectionsAddresses.length == 0); 

        _questionIsActive[questionIndex] = false;                 
         
        return true;
    }

    function editQuestionAtIndex(uint questionIndex, string question) returns (bool updated) {
        require(msg.sender == _owner && _voteSelectionsAddresses.length == 0); 
        
        _questions[questionIndex] = stringToBytes32(question);

        return true;
    }

    function totalQuestions() returns (uint totalQuestions) {
        return _questions.length;
    }

    function getQuestionByIndex(uint questionIndex) returns (string question, bool isActive) {
        return (bytes32ToString(_questions[questionIndex]),_questionIsActive[questionIndex]);
    }

    function stringToBytes32(string memory source) returns (bytes32 result) {
        assembly {
            result := mload(add(source, 32))
        }
    }

    function bytes32ToString(bytes32 x) constant returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }

}