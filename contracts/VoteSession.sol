pragma solidity ^0.4.11;

contract VoteSession {
    bytes32[] _questions;
    bool[] _questionIsActive;
    bytes32[] _questionIds;
    address _owner;
    address _voteToken;

    mapping(address => bytes32) _voteSelections;
    mapping(address => bytes32) _voteSessionIds;
    mapping(address => uint) _hasVoted;
    address[] _voteSelectionsAddresses;

    function VoteSession() {
        _owner = msg.sender;
    }

    function setVoteTokenAddress(address voteToken) returns (bool setTokenId){
        require(msg.sender==_owner);
        
        _voteToken = voteToken;

        return true;
    }



    function getVoteTokenAddress() returns (address VoteToken) {
        return _voteToken;
    }

    function vote(string voteSessionId, string selectedAnswers) returns (bool Result) {        
        if (_hasVoted[msg.sender] == 0) {
            _hasVoted[msg.sender] = 1;
            _voteSelectionsAddresses.push(msg.sender);
        }

        _voteSessionIds[msg.sender] = stringToBytes32(voteSessionId);
        _voteSelections[msg.sender] = stringToBytes32(selectedAnswers);

        return true;
    }

    function getLastVoteSessionId() returns (string voteSessionId1) {
        string memory voteSessionId;

        if (_hasVoted[msg.sender] == 0) {
            voteSessionId = "";            
        } else {
            voteSessionId = bytes32ToString(_voteSessionIds[msg.sender]);
        }

        return voteSessionId;
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


    function addQuestion(string questionId, string question) returns (bool added) {
        require(msg.sender == _owner && _voteSelectionsAddresses.length == 0); 
                
        _questions.push(stringToBytes32(question));
        _questionIsActive.push(true);
        _questionIds.push(stringToBytes32(questionId));

        return true;
    }

    function removeQuestionAtIndex(uint questionIndex) returns (bool removed) {
        require(msg.sender == _owner && _voteSelectionsAddresses.length == 0); 

        _questionIsActive[questionIndex] = false;                 
         
        return true;
    }

    function editQuestionAtIndex(uint questionIndex, string questionId, string question) returns (bool updated) {
        require(msg.sender == _owner && _voteSelectionsAddresses.length == 0); 
        
        _questions[questionIndex] = stringToBytes32(question);
        _questionIds[questionIndex] = stringToBytes32(questionId);

        return true;
    }

    function totalQuestions() returns (uint totalQuestions) {
        return _questions.length;
    }

    function getQuestionByIndex(uint questionIndex) returns (string questionId, string question, bool isActive) {
        return (bytes32ToString(_questionIds[questionIndex]),bytes32ToString(_questions[questionIndex]),_questionIsActive[questionIndex]);
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