const { time } = require('console');
const express = require('express')
const mongoose = require('mongoose')
const path = require('path');
const { stringify } = require('querystring');
const port = 3019

const app = express();
app.use(express.static(__dirname));
app.use(express.urlencoded({extended:true}))

mongoose.connect('mongodb://localhost:27017/')
const db = mongoose.connection
db.once('open',()=>{
    console.log("mongodb connection successful")
})  

const userSchema = new mongoose.Schema({
regd_no:String,
name:String,
email:String,
date:Date,
time:Number

})
const users = mongoose.model("data",userSchema)
     
app.get('/',(req,res)=> {
    res.sendFile(path.join(__dirname,'form.html'))
})
app.post('/post',async(req,res)=>{
    const{regd_no,name,email,date,time} = req.body
    const user = new users({
        regd_no,
        name,
        email,
        date,
        time
    })
    await user.save()
    console.log(user)
    res.send("Reservation successful")
})

app.listen(port,()=>{
    console.log("server started")
})