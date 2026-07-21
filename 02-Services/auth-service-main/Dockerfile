FROM golang:1.22-alpine AS builder
RUN adduser -D LucasDev
USER LucasDev
WORKDIR /app
COPY  --chown=LucasDev:LucasDev go.mod ./
COPY --chown=LucasDev:LucasDev . .
RUN go mod tidy
RUN go build -o /app/auth-service-main .
#RUN go test ./...


FROM alpine:3.20
RUN adduser -D LucasDev
USER LucasDev
WORKDIR /app
#RUN go test ./...
COPY --from=builder --chown=LucasDev:LucasDev /app/auth-service-main  /app/auth-service
EXPOSE 8001
CMD ["/app/auth-service"]


#testar sem cache
# docker build --target builder -t auth-service-builder-test ./auth-service-main
#refazer sem usar camada anterior
#docker builder prune -af
# docker build --no-cache -t auth-service-test ./auth-service-main