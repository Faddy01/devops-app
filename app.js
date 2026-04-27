const http = require("http");

const server = http.createServer((req, res) => {
  if (req.url === "/health") {
    res.writeHead(200, { "Content-Type": "text/plain" });
    return res.end("OK");
  }

  res.writeHead(200, { "Content-Type": "text/plain" });
  res.end("Hello from DevOps CI/CD Pipeline 🚀");
});

server.listen(3000, () => {
  console.log("Server running on port 3000");
});
