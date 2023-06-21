
const express=require("express");
const mongoose=require("mongoose");
const authRouter = require("./middewares/auth")
const cros=require("cors");
const http=require("http");
const documentRouter = require("./routes/document");
const { Socket } = require("dgram");
const PORT=process.env.PORT| 3001;


const app=express();
var server=http.createServer(app);
var io=require('socket.io')(server);


app.use(cros());
app.use(express.json());
app.use(documentRouter);

app.use(authRouter);

const DB="mongodb+srv://hammad:hammadQ@cluster0.bdmmcts.mongodb.net/?retryWrites=true&w=majority";

mongoose.connect(DB)
.then(()=>{
    console.log("Connection successful!");
}).catch((err)=>{
    console.log(err);
});
io.on("connection",(socket)=>{
    socket.on('join',(documentId)=>{
        socket.join(documentId);
    });
    socket.on('typing',(data)=>{
        socket.broadcast.to(data.room).emit('changes',data);
    });

    socket.on('save',async(data)=>{
        saveData(data);
    
    });
});

const saveData=async (data)=>{
    let document=await Document.findById(data.room);
    document.connect=data.delta;
    document=await document.save();
}

server.listen(PORT,"0.0.0.0",()=>
{console.log(`connected at port${PORT}`);
}
);