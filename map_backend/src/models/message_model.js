import mongoose from "mongoose";


const messageSchema= mongoose.Schema({
    senderId: {
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true
    },
    content: {
        type: String,
        required: true,
    },
    conversationId: {
        type: mongoose.Schema.ObjectId,
        ref: 'Conversation',
        required: true
    },
    timestamps: {
        type: Date,
        default: Date.now()
    }
}, {
    timestamps: true
});

const Message=mongoose.model('Message', messageSchema);

export default Message;