const http = require("http");

const server = http.createServer((req, res) => {

  if (req.url === "/health") {
    res.end("OK");
    return;
  }

  res.end("🚀 Production DevOps App Running");
});

server.listen(3000);
