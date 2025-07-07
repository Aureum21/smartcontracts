// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./registerInst.sol";
import "./institute.sol";

contract verifyinst {
    address public MOE;
    registerInst public instreg;
    constructor(address _registerInstAddress) {
        MOE = msg.sender;
        instreg = registerInst(_registerInstAddress);
    }
    modifier onlyMOE() {
        require(msg.sender == MOE);
        _;
    }
    string[] public institution_names;
    mapping(address => address) public registeredinstitutesmap;
    mapping(string =>address) public instNameToAddress;
    address[] registeredinstitutes;

    function verifyInstitution(bytes32 key, uint256 index,address newinst) public onlyMOE {
        (
            string memory institute_name,
            address institute_address,,
        ) = instreg.getPendingInstituteByKey(key);
        
        registeredinstitutesmap[institute_address] = newinst;
        registeredinstitutes.push(institute_address);
        instreg.removePendingInstitute(key, index);
        instNameToAddress[institute_name]=institute_address;
        institution_names.push(institute_name);
    }
    function getInstitutesCount() public view returns (uint256) {
        return institution_names.length;
    }
    function getAddresByName(string memory name) public view returns (address){
        return instNameToAddress[name];
    }
    function getInstituteByIndex(
        uint256 index
    ) public view returns (string memory) {
        return institution_names[index];
    }

    function getPendingInstitutesCount() public view returns (uint256) {
        return instreg.getPendingInstitutesCount();
    }

    function getPendingInstituteByKey(
        bytes32 key
    ) public view returns (string memory, address, string memory, address) {
        return instreg.getPendingInstituteByKey(key);
    }

    function isinstitute(address _institutes) public view returns (bool) {
        return registeredinstitutesmap[_institutes] != address(0x0);
    }

    function instituteCount() public view returns (uint256) {
        return registeredinstitutes.length;
    }

    function getinstitutesContractByAddress(
        address _institutes
    ) public view returns (address) {
        return registeredinstitutesmap[_institutes];
    }

}