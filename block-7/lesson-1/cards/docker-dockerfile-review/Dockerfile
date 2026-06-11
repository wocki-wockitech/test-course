# Вариант A
FROM golang:1.22
WORKDIR /app
COPY . .
RUN go mod download
RUN go build -o server ./cmd/server
USER root
CMD ["./server"]

# Вариант B
FROM golang:1.22 AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o /out/server ./cmd/server

FROM alpine:3.20
RUN adduser -D app
USER app
COPY --from=build /out/server /server
ENTRYPOINT ["/server"]
