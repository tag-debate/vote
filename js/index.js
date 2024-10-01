const moment = require('moment');
const { castVote } = require('./utils/voteCounter');
const { voterRegistry } = require('./utils/voterRegistry');

// Função de votação com restrição de data
function vote(candidateId, voterId, currentTime) {
  const votingDeadline = moment('2023-12-31'); // Definir o prazo de votação

  // Ensure currentTime is a valid moment object
  if (!moment.isMoment(currentTime)) {
    throw new Error("O tempo atual fornecido não é válido.");
  }

  if (currentTime.isAfter(votingDeadline)) {
    throw new Error("O período de votação terminou.");
  }

  // Verifica se o eleitor já votou
  if (voterRegistry[voterId]) {
    throw new Error("O eleitor já votou.");
  }

  // Registra o eleitor e permite a votação
  voterRegistry[voterId] = true;
  
  // Registra o voto para o candidato
  castVote(candidateId);
}