// Módulo responsável por gerenciar o registro de eleitores
let voterRegistry = {}; // Armazenará os IDs dos eleitores que já votaram

/**
 * Função para registrar o voto de um eleitor e garantir que ele só vote uma vez.
 * 
 * @param {number} candidateId - O ID do candidato para quem o voto está sendo emitido.
 * @param {number} voterId - O ID do eleitor que está votando.
 * @throws {Error} Se o eleitor já tiver votado.
 */
function vote(candidateId, voterId) {
    // Verifica se o eleitor já votou
    if (voterRegistry[voterId]) {
        throw new Error("O eleitor já votou.");
    }

    // Marca o eleitor como tendo votado
    voterRegistry[voterId] = true;

    // Chama a função que registra o voto para o candidato
    castVote(candidateId, voterId);
}

/**
 * Função que reseta o registro de eleitores. 
 * Pode ser usada para simulações ou no início de uma nova eleição.
 */
function resetVoterRegistry() {
    voterRegistry = {}; // Reseta o registro de eleitores para uma nova eleição
}

/**
 * Função para verificar se um eleitor já votou.
 * 
 * @param {number} voterId - O ID do eleitor.
 * @returns {boolean} true se o eleitor já tiver votado, false caso contrário.
 */
function hasVoted(voterId) {
    return !!voterRegistry[voterId];
}

module.exports = {
    vote,
    resetVoterRegistry,
    hasVoted
};