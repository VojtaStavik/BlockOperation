import UIKit

public class BlockOperation: NSOperation {
    private var _finished : Bool = false
    private var _executing : Bool = false
    
    private var operationBlock: (() -> Void) -> Void!
    
    init(block: (() -> Void) -> Void) {
        self.operationBlock = block
        super.init()
    }
    
    override public var asynchronous : Bool  {
        return true
    }
    
    override public var executing : Bool {
        get { return _executing }
        set {
            if newValue == true {
                willChangeValueForKey("isExecuting")
                _executing = newValue
                didChangeValueForKey("isExecuting")
            } else {
                willChangeValueForKey("isExecuting")
                _executing = newValue
                didChangeValueForKey("isExecuting")
            }
        }
    }
    
    override public var finished : Bool {
        get { return _finished }
        set {
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }
    
    override public func start() {
        // Always check for cancellation before launching the task.
        if self.cancelled {
            self.finish()
            return
        }
        
        executing = true
        self.main()
    }
    
    public func finish() {
        executing = false
        finished = true
    }
    
    override public func main() {
        self.operationBlock { [weak self] in
            self?.finish()
        }
    }
}
