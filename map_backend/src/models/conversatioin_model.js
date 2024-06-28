import mongoose from "mongoose";

const conversationSchema = mongoose.Schema({
    participants: [{
        type: mongoose.Schema.ObjectId,
        ref: 'User',
        required: true
    }],
    messages: [{
        type: mongoose.Schema.ObjectId,
        ref: 'Message'
    }]
}, {
    timestmaps: true
});

const Conversation = mongoose.model('Conversation', conversationSchema);

export default Conversation;