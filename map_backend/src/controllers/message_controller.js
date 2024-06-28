import { populate } from "dotenv";
import Conversation from "../models/conversatioin_model.js";
import Message from "../models/message_model.js";
import User from "../models/user_model.js";


export const getUser = async (req, res) => {

    const user = req.user;
    return res.status(200).json({ 'user': user });

}


export const createConversation = async (req, res) => {
    const { userId1, userId2 } = req.body;

    try {
        let conversation = await Conversation.findOne({
            participants: { $all: [userId1, userId2], $size: 2 }
        }).populate('participants');

        if (conversation) {
            return res.status(200).json({ conversation });
        }
        conversation = new Conversation({
            participants: [userId1, userId2]
        });
        await conversation.save();
        await conversation.populate('participants').execPopulate();
        return res.status(201).json({ conversation });
    } catch (error) {
        console.error('Error creating conversation:', error);
        return res.status(400).json({ message: error.message });
    }
};


export const sendMessage = async (req, res) => {
    const { content, senderId, conversationId } = req.body;

    try {
        const newMessage = await saveMessage(content, senderId, conversationId);
        res.status(201).json({
            message: newMessage
        });
    } catch (error) {
        console.error('Error sending message:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};


export const saveMessage = async (content, senderId, conversationId) => {
    try {
        const conversation = await Conversation.findById(conversationId);

        if (!conversation) {
            throw new Error('Conversation not found');
        }


        let newMessage = new Message({
            content: content,
            senderId: senderId,
            conversationId: conversationId
        });

        await newMessage.save();

        conversation.messages.push(newMessage._id);
        await conversation.save();

        console.log(`message: ${newMessage}`)

        return newMessage;
    } catch (error) {
        throw new Error(error.message);
    }
};

export const addFriend = async (req, res) => {
    console.log('here');
    try {
        const friendId = req.params.friendId;
        const user = req.user;
        const userId = user.id;

        let friend = await User.findById(friendId);

        if (!friend) return res.status(404).json({ error: 'Friend not found' });

        let conversation = await Conversation.findOne({
            participants: { $all: [friendId, userId], $size: 2 }
        });

        if (!conversation) {
            conversation = new Conversation({
                participants: [userId, friendId]
            });
            await conversation.save();
        }

        if (!user.conversations) user.conversations = [];
        if (!friend.conversations) friend.conversations = [];

        if (user.conversations.includes(conversation._id)) {
            if (friend.conversations.includes(conversation._id)) {
                return res.status(401).json({ message: 'already a friend' })
            }
        }


        let conversationId = conversation._id;

        user.conversations.push(conversationId);
        friend.conversations.push(conversationId);

        await user.save();
        await friend.save();

        return res.status(200).json({ message: 'Conversation room created!' });

    } catch (error) {
        console.error(error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};


export const getAllUsers = async (req, res) => {
    console.log('getlllusers')
    try {
        const users = await User.find()
        console.log(users)
        return res.status(200).json({
            'users': users
        });
    } catch (error) {
        console.log(error);
        res.status(401).json({
            'message': error.message
        })
    }
}


export const getFriends = async (req, res) => {
    const userId = req.user.id;

    try {
        const user = await User.findById(userId).populate({
            path: 'conversations',
            populate: {
                path: 'participants'
            }
        });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        return res.status(200).json({
            conversations: user.conversations
        });
    } catch (error) {

        console.error('Error fetching user:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};

export const getMessages = async (req, res) => {
    const { conversationId, page, limit } = req.body;

    console.log(req.body)

    const pageNumber = parseInt(page) || 1;
    const limitNumber = parseInt(limit) || 10;

    try {
        const conversation = await Conversation.findById(conversationId).populate({
            path: 'messages',
            options: {
                sort: { createdAt: -1 }, // Sort messages by createdAt in descending order
                skip: (pageNumber - 1) * limitNumber,
                limit: limitNumber
            }
        });

        if (!conversation) {
            return res.status(404).json({ message: 'Conversation not found' });
        }

        const messages = conversation.messages;
        console.log(`len: ${messages.length}`)

        res.status(200).json({
            messages,
            currentPage: pageNumber,
            totalPages: Math.ceil(messages.length / limitNumber),
            totalMessages: messages.length
        });
    } catch (error) {
        res.status(500).json({ message: 'Failed to fetch messages', error: error.message });
    }
};