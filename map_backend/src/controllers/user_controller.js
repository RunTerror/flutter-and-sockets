import User from '../models/user_model.js';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

// User registration
export const registerUser = async (req, res) => {
    try {
        const { name, email, password } = req.body;

        const existingUser = await User.findOne({ email: email });
        if (existingUser) {
            return res.status(400).send({ error: 'Email already in use' });
        }

        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        const newUser = new User({
            name: name,
            email: email,
            password: hashedPassword,
        });
        console.log(`user: ${newUser}`)
        
        await newUser.save();

        const token = jwt.sign({ id: newUser._id }, 'Secret', { expiresIn: '36500d' });

        res.status(201).send({ 
            user: newUser, token
        });
    } catch (error) {
        console.log(error);
        res.status(500).send({ error: 'Internal server error' });
    }
};


// User login
export const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        const user = await User.findOne({ email: email })
        if (!user) {
            return res.status(400).send({ error: 'Invalid login credentials' });
        }

        const isCorrect = await bcrypt.compare(password, user.password);
        if (!isCorrect) {
            return res.status(400).send({ error: 'Invalid login credentials' });
        }

        const token = jwt.sign({ id: user._id }, 'Secret', { expiresIn: '36500d' });

        res.send({ user,  token });
    } catch (error) {
        console.log(error);
        res.status(500).send({ error: 'Internal server error' });
    }
};
