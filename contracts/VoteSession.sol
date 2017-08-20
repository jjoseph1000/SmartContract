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

    function getQuestionByIndex(uint questionIndex) returns (bytes32 question) {
        return _questions[questionIndex];
    }

    function stringToBytes32(string memory source) returns (bytes32 result) {
        assembly {
            result := mload(add(source, 32))
        }
    }

}