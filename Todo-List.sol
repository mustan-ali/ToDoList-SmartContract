// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract TodoList {
    address public owner;

    struct Task {
        uint256 id;
        string content;
        bool completed;
    }

    mapping(uint256 => Task) public tasks;
    uint256 public taskCount;
    event TaskCreated(uint256 id, string content, bool completed);
    event TaskCompleted(uint256 id, bool completed);
    event TaskDeleted(uint256 id);
    event TaskUpdated(uint256 id, string content);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function createTask(string memory _content) public onlyOwner {
        taskCount++;
        tasks[taskCount] = Task(taskCount, _content, false);
        emit TaskCreated(taskCount, _content, false);
    }

    function completeTask(uint256 _id) public onlyOwner {
        require(_id > 0 && _id <= taskCount, "Task does not exist");
        Task storage _task = tasks[_id];
        _task.completed = true;
        emit TaskCompleted(_id, true);
    }

    function deleteTask(uint256 _id) public onlyOwner {
        require(_id > 0 && _id <= taskCount, "Task does not exist");
        delete tasks[_id];
        taskCount--;
        for (uint256 i = _id; i <= taskCount; i++) {
            tasks[i] = tasks[i + 1];
            tasks[i].id = i;
        }
        delete tasks[taskCount + 1];
        emit TaskDeleted(_id);
    }

    function updateTask(uint256 _id, string memory _content) public onlyOwner {
        require(_id > 0 && _id <= taskCount, "Task does not exist");
        tasks[_id].content = _content;
        emit TaskUpdated(_id, _content);
    }

    function getTask(uint256 _id) public view onlyOwner returns (Task memory) {
        require(_id > 0 && _id <= taskCount, "Task does not exist");
        return tasks[_id];
    }

    function getAllTasks() public view onlyOwner returns (Task[] memory) {
        Task[] memory _tasks = new Task[](taskCount);
        for (uint256 i = 1; i <= taskCount; i++) {
            _tasks[i - 1] = tasks[i];
        }
        return _tasks;
    }
}