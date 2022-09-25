FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

WORKDIR /app

# csproj 파일만 복사하고, 프로젝트에서 참조하는 패키지를 별도의 레이어에서 복원한다.
COPY *.csproj ./
RUN dotnet restore

# 나머지 파일들을 모두 복사하고, 프로젝트를 빌드한다.
COPY . ./

# 빌드 산출물은 /app/out 에 떨어트린다.
RUN dotnet publish -c Release -o out

# 빌드 도구가 없는 실행 전용 이미지를 빌드한다
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT [ "dotnet", "docker-app.dll" ]
