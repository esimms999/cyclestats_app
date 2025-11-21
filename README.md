# cyclestats
Analysis of Cycling Data


GitHub: esimms999/cyclestats_app

docker build --no-cache --progress=plain -t cyclestats-shiny . > docker-build.log 2>&1

docker tag cyclestats-shiny esimms999/cyclestats:latest

docker save cyclestats-shiny:latest | gzip > cyclestats_final_working_yyyy-mm-dd.tar.gz

docker run --user shiny -d -it -p 3838:3838 esimms999/cyclestats
