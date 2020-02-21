docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
