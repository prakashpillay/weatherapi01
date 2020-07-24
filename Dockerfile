FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as build-env
WORKDIR /app

#copy csproj and restore
COPY *.csproj ./
RUN dotnet restore

#copy everything else and build
COPY . ./
RUN dotnet publish -c release -o out

#generate runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
EXPOSE 80
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "weatherapi.dll"]