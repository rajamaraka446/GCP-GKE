const express=require('express');const app=express();app.get('/',(_,r)=>r.send('OK'));app.listen(8080);
