import { mongoose } from "mongoose";

const userSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
        trim: true,
    },
    password: {
        type: String,
        required: true,
        length: 6
    },
    conversations: [{
        type: mongoose.Schema.ObjectId,
        ref: 'Conversation',
    }],
    friends: [{
        type: mongoose.Schema.ObjectId,
        ref: 'User',
    }]
}, {
    timestamps: true
});

const User = mongoose.model('User', userSchema);

export default User;

