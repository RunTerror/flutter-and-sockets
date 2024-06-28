import express, { json } from 'express'
import { createServer } from 'http'
import { mongoose } from 'mongoose'
import { Server } from 'socket.io'
import userRoute from './router/user_routes.js'
import Message from './models/message_model.js'
import Conversation from './models/conversatioin_model.js'
import { saveMessage } from './controllers/message_controller.js'

const app = express();
const server = createServer(app);
const io = new Server(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});

mongoose.Promise = global.Promise;

mongoose.connect('mongodb+srv://bansalabhishek7411:beacon123@cluster0.4ot2tpn.mongodb.net/?retryWrites=true&w=majority')
    .then(() => {
        console.log('Connected to MongoDB');
    })
    .catch(err => {
        console.error('Error connecting to MongoDB:', err.message);
    });

app.use(json());

// User routes
app.use('/api/users', userRoute);
app.use('/vc-api/:id', (req, res) => {
    let { id } = req.params;
    res.send(`This is Video Calling Api: ${id}`);
});


io.on('connection', (socket) => {

    console.log(socket)



    console.log('A user connected:', socket.id);

    socket.on('joinConversation', (conversationId) => {
        socket.join(conversationId);
        console.log(`User joined conversation: ${conversationId}`);
    })

    socket.on("sendMessage", async (data) => {
        const { conversationId, senderId, content } = data;

        console.log(data);

        try {
            const newMessage = await saveMessage(content, senderId, conversationId);
            io.to(conversationId).emit('receiveMessage', newMessage);
        } catch (error) {
            console.error('Error sending message:', error);
        }
    });

    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.id);
    });
});

const PORT = process.env.PORT || 1001;
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
