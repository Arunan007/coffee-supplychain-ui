pragma solidity ^0.4.23;
import "./SupplyChainStorage.sol";
import "./Ownable.sol";

contract CoffeeSupplyChain is Ownable
{
    /*Events*/
    event UserUpdate(address indexed user, string indexed name, string indexed contactNo);
    event UserRoleUpdate(address indexed user, string indexed role);
    event PerformCultivation(address indexed user, bytes32 indexed batchNo);
    event DoneInspection(address indexed user, bytes32 indexed batchNo);
    event DoneHarvesting(address indexed user, bytes32 indexed batchNo);
    event DoneExporting(address indexed user, bytes32 indexed batchNo);
    event DoneImporting(address indexed user, bytes32 indexed batchNo);
    event DoneProcessing(address indexed user, bytes32 indexed batchNo);
    
    /*Modifier*/
    modifier isValidPerformer(bytes32 batchNo, string role) {
    
        require(keccak256(supplyChainStorage.getUserRole(msg.sender)) == keccak256(role));
        require(keccak256(supplyChainStorage.getNextAction(batchNo)) == keccak256(role));
        _;
    }
    
    /* Storage Variables */    
    SupplyChainStorage supplyChainStorage;
    address Owner; 
    
    constructor(address _supplyChainAddress) public {
        supplyChainStorage = SupplyChainStorage(_supplyChainAddress);
        Owner = msg.sender;
    }
    
    
    
    
    /* Create/Update User */
    function updateUser(address _userAddress, string _name, string _contactNo, string _role, bool _isActive) public onlyOwner returns(bool)
    {
        require(_userAddress != address(0));
        
        /* Call Storage Contract */
        bool status = supplyChainStorage.setUser(_userAddress, _name, _contactNo, _role, _isActive);
        
         /*call event*/
        emit UserUpdate(_userAddress,_name,_contactNo);
        emit UserRoleUpdate(_userAddress,_role);
        
        return status;
    }
    
    /* get User */
    function getUser(address _userAddress) public view returns(string name, string contactNo, bool isActive, string role){
        require(_userAddress != address(0));
        
        /*Getting value from struct*/
        (name, contactNo, isActive, role) = supplyChainStorage.getUser(_userAddress);
    
        return (name, contactNo, isActive, role);
    }
         
    /* perform Basic Cultivation */
    
    function addBasicDetails(string _registrationNo,
                             string _farmerName,
                             string _farmAddress,
                             string _exporterName,
                             string _importerName
                            ) public onlyOwner returns(bytes32) {
    
        bytes32 batchNo = supplyChainStorage.setBasicDetails(_registrationNo,
                                                            _farmerName,
                                                            _farmAddress,
                                                            _exporterName,
                                                            _importerName);
        
        emit PerformCultivation(msg.sender, batchNo); 
        
        return (batchNo);
    }                            
    
    /* get Farm Inspection */
    
    function getFarmInspectorData(bytes32 _batchNo) public view returns (string coffeeFamily,string typeOfSeed,string fertilizerUsed) {
        /* Call Storage Contract */
        (coffeeFamily, typeOfSeed, fertilizerUsed) = supplyChainStorage.getFarmInspectorData(_batchNo);  
        
        return (coffeeFamily, typeOfSeed, fertilizerUsed);
    }
    
    /* perform Farm Inspection */
    
    function updateFarmInspectorData(bytes32 _batchNo,
                                    string _coffeeFamily,
                                    string _typeOfSeed,
                                    string _fertilizerUsed) 
                                public isValidPerformer(_batchNo,'FARM_INSPECTION') returns(bool) {
        /* Call Storage Contract */
        bool status = supplyChainStorage.setFarmInspectorData(_batchNo, _coffeeFamily, _typeOfSeed, _fertilizerUsed);  
        
        emit DoneInspection(msg.sender, _batchNo);
        return (status);
    }

    
    /* get Harvest */
    
    function getHarvesterData(bytes32 _batchNo) public view returns (string cropVariety, string tempatureUsed, string humidity) {
        /* Call Storage Contract */
        (cropVariety, tempatureUsed, humidity) = supplyChainStorage.getHarvesterData(_batchNo);  
        
        return (cropVariety, tempatureUsed, humidity);
    }
    
    /* perform Harvest */
    
    function updateHarvesterData(bytes32 _batchNo,
                                string _cropVariety,
                                string _tempatureUsed,
                                string _humidity) 
                                public isValidPerformer(_batchNo,'HARVESTER') returns(bool) {
                                    
        /* Call Storage Contract */
        bool status = supplyChainStorage.setHarvesterData(_batchNo, _cropVariety, _tempatureUsed, _humidity);  
        
        emit DoneHarvesting(msg.sender, _batchNo);
        return (status);
    }
    
    /* get Export */
    
    function getExporterData(bytes32 _batchNo) public view returns (uint256 quantity,
                                                                    string destinationAddress,
                                                                    string shipName,
                                                                    string shipNo,
                                                                    uint256 departureDateTime,
                                                                    uint256 estimateDateTime,
                                                                    uint256 plantNo,
                                                                    uint256 exporterId) {
        /* Call Storage Contract */
        (quantity, 
        destinationAddress, 
        shipName, 
        shipNo, 
        departureDateTime, 
        estimateDateTime,
        plantNo,
        exporterId) = supplyChainStorage.getExporterData(_batchNo);  
        
        return (quantity,destinationAddress,shipName,shipNo,departureDateTime,estimateDateTime,plantNo,exporterId);
    }
    
    /* perform Export */
    
    function updateExporterData(bytes32 _batchNo,
                                uint256 _quantity,    
                                string _destinationAddress,
                                string _shipName,
                                string _shipNo,
                                uint256 _estimateDateTime,
                                uint256 _plantNo,
                                uint256 _exporterId) 
                                public isValidPerformer(_batchNo,'EXPORTER') returns(bool) {
                                    
        /* Call Storage Contract */
        bool status = supplyChainStorage.setExporterData(_batchNo, _quantity, _destinationAddress, _shipName,_shipNo, _estimateDateTime,_plantNo,_exporterId);  
        
        emit DoneExporting(msg.sender, _batchNo);
        return (status);
    }
    
    /* get Import */
    
    function getImporterData(bytes32 _batchNo) public view returns (uint256 quantity,
                                                                    string shipName,
                                                                    string shipNo,
                                                                    uint256 arrivalDateTime,
                                                                    string transportInfo,
                                                                    string warehouseName,
                                                                    string warehouseAddress,
                                                                    uint256 importerId) {
        /* Call Storage Contract */
        (quantity, 
        shipName, 
        shipNo, 
        arrivalDateTime, 
        transportInfo, 
        warehouseName,
        warehouseAddress,
        importerId) = supplyChainStorage.getImporterData(_batchNo);  
        
        return (quantity,shipName,shipNo,arrivalDateTime,transportInfo,warehouseName,warehouseAddress,importerId);
    }
    
    /* perform Import */
    
    function updateImporterData(bytes32 _batchNo,
                                uint256 _quantity, 
                                string _shipName,
                                string _shipNo,
                                string _transportInfo,
                                string _warehouseName,
                                string _warehouseAddress,
                                uint256 _importerId) 
                                public isValidPerformer(_batchNo,'IMPORTER') returns(bool) {
                                    
        /* Call Storage Contract */
        bool status = supplyChainStorage.setImporterData(_batchNo, _quantity, _shipName, _shipNo, _transportInfo,_warehouseName,_warehouseAddress,_importerId);  
        
        emit DoneImporting(msg.sender, _batchNo);
        return (status);
    }
    
    
    /* get Processor */
    
    function getProccesorData(bytes32 _batchNo) public view returns (uint256 quantity,
                                                                    string tempature,
                                                                    uint256 rostingDuration,
                                                                    string internalBatchNo,
                                                                    uint256 packageDateTime,
                                                                    string processorName,
                                                                    string processorAddress) {
        /* Call Storage Contract */
        (quantity, 
        tempature, 
        rostingDuration, 
        internalBatchNo, 
        packageDateTime, 
        processorName,
        processorAddress) = supplyChainStorage.getProccesorData(_batchNo);  
        
        return (quantity,tempature,rostingDuration,internalBatchNo,packageDateTime,processorName,processorAddress);
    }
    
    /* perform Processing */
    
    function updateProcessorData(bytes32 _batchNo,
                              uint256 _quantity, 
                              string _tempature,
                              uint256 _rostingDuration,
                              string _internalBatchNo,
                              uint256 _packageDateTime,
                              string _processorName,
                              string _processorAddress) public isValidPerformer(_batchNo,'PROCESSOR') returns(bool) {
                                    
        /* Call Storage Contract */
        bool status = supplyChainStorage.setProcessorData(_batchNo, 
                                                        _quantity, 
                                                        _tempature, 
                                                        _rostingDuration, 
                                                        _internalBatchNo,
                                                        _packageDateTime,
                                                        _processorName,
                                                        _processorAddress);  
        
        emit DoneProcessing(msg.sender, _batchNo);
        return (status);
    }
    
    
    
    
    
   
    
    
    
}