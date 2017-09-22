pragma solidity ^0.4.11;

contract VoteSessionBroadRidge {
    bytes32[] _questionIds;
    mapping(bytes32 => uint) _questionTextRows;
    mapping(bytes32 => mapping(uint => bytes32)) _questionText;
    mapping(bytes32 => bytes32) _boardRecommendation;
    mapping(bytes32 => uint) _questionIsActive;
    mapping(bytes32 => uint) _hasQuestion;


    address _owner;

    mapping(address => bytes32) _voteSelections;
    mapping(address => bytes32) _voteSessionIds;
    mapping(address => uint256) _voteShares;
    mapping(address => uint) _blockNumbers;
    mapping(address => uint) _hasVoted;
    address[] _voteSelectionsAddresses;

    function VoteSessionBroadRidge() {
        _owner = msg.sender;
    }

    function vote(address voter,string voteSessionId, string selectedAnswers, uint256 voteShares) returns (bool Result) {        
        require(_owner == msg.sender);
        
        if (_hasVoted[voter] == 0) {
            _hasVoted[voter] = 1;
            _voteSelectionsAddresses.push(voter);
        }

        _voteSessionIds[voter] = stringToBytes32(voteSessionId);
        _voteShares[voter] = voteShares;
        _voteSelections[voter] = stringToBytes32(selectedAnswers);
        _blockNumbers[voter] = block.number;

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

    function getVoteAnswers() returns (uint256 indexVoter1,address voter, string voteSessionId, string voteAnswers, uint blockNumber, uint256 balance) {
        return (getVoteAnswersByAddress(0,msg.sender));
    }

    function getVoteAnswersByIndex(uint256 voterIndex) returns (uint256 indexVoter1,address voter, string voteSessionId, string voteAnswers, uint blockNumber, uint256 balance) {
        address selectedAddress = _voteSelectionsAddresses[voterIndex];
        return (getVoteAnswersByAddress(voterIndex,selectedAddress));
    }

    function getVoteAnswersByAddress(uint256 indexVoter,address voterAddress) returns (uint256 indexVoter1,address voter, string voteSessionId, string voteAnswers, uint blockNumber, uint256 balance) {
        return (indexVoter, voterAddress, bytes32ToString(_voteSessionIds[voterAddress]), bytes32ToString(_voteSelections[voterAddress]), _blockNumbers[voterAddress],_voteShares[voterAddress]);
    }

    function insertUpdateQuestion(string questionId, uint questionTextRows, bytes32 questionText, string boardRecommendation, uint isActive) returns (bool insertupdate) {
        require(_owner == msg.sender);
        
        bytes32 bytesQuestionId = stringToBytes32(questionId);
        if (_hasQuestion[bytesQuestionId] == 0) {
            _hasQuestion[bytesQuestionId] = 1;
            _questionIds.push(bytesQuestionId);
        }

        _questionTextRows[bytesQuestionId] = questionTextRows;
        _boardRecommendation[bytesQuestionId] = stringToBytes32(boardRecommendation);
        _questionIsActive[bytesQuestionId] = isActive;
        _questionText[bytesQuestionId][0] = questionText;
    }
    function addQuestionTextRow(string questionId, uint questionTextRow, bytes32 questionText) returns (bool success) {
        require(_owner == msg.sender);
        
        bytes32 bytesQuestionId = stringToBytes32(questionId);
        _questionText[bytesQuestionId][questionTextRow] = questionText;

        return true;
    } 

    function getQuestionTextByRow(string questionId, uint questionTextRow) returns (string questionid, uint row, bytes32 textLine) {
        bytes32 bytesQuestionId = stringToBytes32(questionId);
        return (questionId, questionTextRow,_questionText[bytesQuestionId][questionTextRow]);
    }

    function totalQuestions() returns (uint totalQuestions) {
        return _questionIds.length;
    }

    function getQuestionByIndex(uint questionIndex) returns (uint questionIndex1, string questionId, uint questionTextRows, string boardRecommendation,uint isActive) {
        bytes32 bytesQuestionId = _questionIds[questionIndex];
        return (questionIndex, bytes32ToString(_questionIds[questionIndex]),_questionTextRows[bytesQuestionId],bytes32ToString(_boardRecommendation[bytesQuestionId]),_questionIsActive[bytesQuestionId]);
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