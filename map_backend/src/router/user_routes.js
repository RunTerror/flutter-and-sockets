import { Router } from 'express'
import { loginUser, registerUser } from '../controllers/user_controller.js'
import { addFriend, createConversation, getAllUsers, getFriends, getMessages, getUser, sendMessage } from '../controllers/message_controller.js'
import authMiddleware from '../middleware/auth_middleware.js'

const router = Router()

router.post('/register', registerUser)
router.post('/login', loginUser)
router.post('/getUser', authMiddleware, getUser)
router.post('/conversation',authMiddleware , createConversation)
router.post('/sendMessages',authMiddleware , sendMessage)
router.post('/get-users',authMiddleware ,getAllUsers)
router.post('/add-friend/:friendId', authMiddleware, addFriend)
router.post('/get-friends', authMiddleware, getFriends);
router.post('/getMessages', authMiddleware, getMessages);

export default router
