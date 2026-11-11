FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Certificat d'entreprise facultatif (inspection SSL Zscaler) : utilisé s'il existe, ignoré sinon
COPY global.json *.crt /tmp/certs/
RUN cp /tmp/certs/*.crt /usr/local/share/ca-certificates/ 2>/dev/null || true \
 && update-ca-certificates

# Fichiers de solution + configuration centrale (TargetFramework, versions NuGet, SDK)
COPY *.sln Directory.Packages.props global.json ./

# Tous les projets référencés par Web.csproj
COPY src/Web/*.csproj src/Web/
COPY src/ApplicationCore/*.csproj src/ApplicationCore/
COPY src/Infrastructure/*.csproj src/Infrastructure/
COPY src/BlazorAdmin/*.csproj src/BlazorAdmin/
COPY src/BlazorShared/*.csproj src/BlazorShared/

# Restauration ciblée (mise en cache tant que les .csproj ne changent pas)
RUN dotnet restore src/Web/Web.csproj

# Copie du reste du code source et publication
COPY . .
RUN dotnet publish src/Web/Web.csproj -c Release -o /app/out

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./
ENTRYPOINT ["dotnet", "Web.dll"]