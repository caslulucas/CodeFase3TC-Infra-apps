FROM golang:1.22-alpine AS builder
RUN adduser -D LucasDev
USER LucasDev
WORKDIR /app
COPY --chown=LucasDev:LucasDev go.mod go.sum ./
COPY --chown=LucasDev:LucasDev . .
RUN go mod tidy
RUN go build -o /app/evaluation-service-main .



FROM alpine:3.20
RUN apk add --no-cache ca-certificates && \ 
    adduser -D LucasDev
WORKDIR /app
COPY --from=builder --chown=LucasDev:LucasDev /app/evaluation-service-main /app/evaluation-service
USER LucasDev
EXPOSE 8004
CMD ["/app/evaluation-service"]








#testar sem cache
# docker build --target builder -t evaluation-service-builder-test ./evaluation-service-main
#refazer sem usar camada anterior
#docker builder prune -af
# docker build --no-cache -t evaluation-service-test ./evaluation-service-main