#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine AS base
WORKDIR /app
EXPOSE 5000
ENV RABBITMQ_HOST localhost
ENV RABBITMQ_PORT 5672 

FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build
WORKDIR /src
COPY ["Producer88.csproj", "."]
RUN dotnet restore "./Producer88.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Producer88.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Producer88.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Producer88.dll"]