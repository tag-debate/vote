// Módulo para rastrear e contar os votos por candidato
let candidateVotes = {};

// Função para registrar o voto de um eleitor para um candidato
function castVote(candidateId, voterId) {
    // Verifica se o candidato já está no registro de votos
    if (!candidateVotes[candidateId]) {
        candidateVotes[candidateId] = 0; // Inicializa o contador de votos para o candidato
    }
    
    // Incrementa o número de votos para o candidato
    candidateVotes[candidateId] += 1;
}

// Função para recuperar a contagem de votos de um candidato específico
function getVoteCount(candidateId) {
    // Retorna o número de votos para o candidato ou 0 se o candidato não tiver votos
    return candidateVotes[candidateId] || 0;
}

// Função para resetar a contagem de votos (opcional, para cenários de teste)
function resetVoteCount() {
    candidateVotes = {}; // Reseta o objeto de contagem de votos
}

// Exporta as funções para uso externo
module.exports = {
    castVote,
    getVoteCount,
    resetVoteCount
};