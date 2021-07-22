FROM swift:5.2.3 AS build-image

WORKDIR /src
COPY . .
RUN swift build -c release
WORKDIR /home/site/wwwroot
RUN [ "/src/.build/release/functions", "export", "--source", "/src", "--root", "/home/site/wwwroot" ]

FROM mcr.microsoft.com/azure-functions/base:3.0 as functions-image

FROM salehalbuga/azure-functions-swift-runtime-classic:1.0

COPY --from=functions-image [ "/azure-functions-host", "/azure-functions-host" ]

COPY --from=build-image ["/home/site/wwwroot", "/home/site/wwwroot/"]

CMD [ "/azure-functions-host/Microsoft.Azure.WebJobs.Script.WebHost" ]
