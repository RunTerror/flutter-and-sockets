import jwt from 'jsonwebtoken';
import User from '../models/user_model.js';

const authMiddleware = async (req, res, next) => {
    const token = req.header('Authorization')?.replace('Bearer ', '');
    if (!token) return res.status(401).json({ message: 'User not authenticated' });

    try {
        const decoded = jwt.verify(token, 'Secret', { algorithms: ['HS256'] });
        const user = await User.findById(decoded.id);
        if (!user) return res.status(401).json({ message: 'User not authenticated' });
        req.user = user;
        next(); 
    } catch (error) {
        console.error('Token verification error:', error.message);
        return res.status(401).json({ message: 'Token is not valid' });
    }
};

export default authMiddleware;
