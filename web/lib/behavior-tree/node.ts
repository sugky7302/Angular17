export enum NodeStatus {
    SUCCESS,
    FAILURE,
    RUNNING,
    IDLE,
};

export abstract class Node {
    constructor(
        private _parent: Node | null = null,
        // 儲存上下文
        private _context: {[key: string]: any} = {},
        // 節點狀態
        public status: NodeStatus = NodeStatus.IDLE,
    ){}
    
    // 只有第一次呼叫時會執行
    abstract start(): NodeStatus;
    // 每次呼叫都會執行
    abstract run(): NodeStatus;
    // 結束時呼叫
    abstract finish(): NodeStatus;
    
    public setData(key: string, value: any) {
        this._context[key] = value;
    }

    // getData 會從自己的 context 開始找，找不到再往上找。
    // 只會找父節點，不會找兄弟節點。
    public getData(key: string): any {
        if (Object.hasOwnProperty.call(this._context, key)) {
            return this._context[key];
        }

        let value: any;
        while (this._parent) {
            value = this._parent.getData(key);
            if (value !== undefined && value !== null) {
                return value;
            }
        }

        return undefined;
    }
}