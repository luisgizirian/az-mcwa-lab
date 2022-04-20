FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY src/Api.Internal/Api.Internal.csproj Api.Internal/
COPY src/Common.Lib/Common.Lib.csproj Common.Lib/
RUN dotnet restore "Api.Internal/Api.Internal.csproj"

COPY src/Api.Internal ./Api.Internal/
COPY src/Common.Lib ./Common.Lib/

WORKDIR "/src/Api.Internal"
RUN dotnet build "Api.Internal.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Api.Internal.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Api.Internal.dll"]
