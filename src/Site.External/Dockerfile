FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY src/Site.External/Site.External.csproj Site.External/
COPY src/Common.Lib/Common.Lib.csproj Common.Lib/
RUN dotnet restore "Site.External/Site.External.csproj"

COPY src/Site.External ./Site.External/
COPY src/Common.Lib ./Common.Lib/

WORKDIR "/src/Site.External"
RUN dotnet build "Site.External.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Site.External.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Site.External.dll"]
