pragma solidity ^0.4.11;

contract VoteSession {
    bytes32[] _questions;
    address _owner;

    mapping(address => string[]) _voteSelections;
    address[] _voteSelectionsAddresses;

    function VoteSession() {
        _owner = msg.sender;
    }

    // function Vote(string selectedAnswers) returns (bool Result) {
    //     string[] voteChoices;



    //     return true;
    // }

    function addQuestion(string question) returns (bool added) {
        require(msg.sender == _owner); 
                
        _questions.push(stringToBytes32(question));

        return true;
    }

    function removeQuestionAtIndex(uint questionIndex) returns (bool removed) {
        require(msg.sender == _owner); 
        
        bytes32[] newQuestions;        

        for (uint i =0;i<_questions.length;i++) {
            if (i != questionIndex) {
                newQuestions.push(_questions[i]);
            }
        }

        _questions = newQuestions;        

        return true;
    }

    function editQuestionAtIndex(uint questionIndex, string question) returns (bool updated) {
        require(msg.sender == _owner); 
        
        _questions[questionIndex] = stringToBytes32(question);

        return true;
    }

    function totalQuestions() returns (uint totalQuestions) {
        return _questions.length;
    }

    function getQuestionByIndex(uint questionIndex) returns (string question) {
        return bytes32ToString(_questions[questionIndex]);
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