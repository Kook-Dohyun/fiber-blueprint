cd C:\Coding\dart_projects\icncast_kook\fiber_server
docker run -it --rm --name fiber-test `
  --cpus="2" --memory="4g" `
  -p 8080:8080 `
  -v "$(Get-Location):/app" `
  -w /app `
  golang:1.23.2 bash