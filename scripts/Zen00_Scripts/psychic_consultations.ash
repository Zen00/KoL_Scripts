/********************************************

				Psychic Consultation
					By: Zen00
					V. 1.0
Gets your psychic consultations and answers them, hassle free!
				
********************************************/

script "Psychic Consultation";
since r20000;
int[int] clannies = {};

void enumerateClannies() {
	buffer page_text = visit_url("clan_members.php");
	string[int][int] matches = page_text.group_string("p?who=(\\d+)");
	foreach key in matches {
		int player_id = matches[key][1].to_int();
		if (player_id <= 0) { continue; }
		clannies[key] = player_id;
	}
}

void consultbotAnswerQuestions() {
	buffer page_text = visit_url("clan_viplounge.php?preaction=lovetester");
	string[int][int] matches = page_text.group_string("clan_viplounge.php.preaction=testlove&testlove=([0-9]+)");
	foreach key in matches {
		int player_id = matches[key][1].to_int();
		if (player_id <= 0) { continue; }
		print("My love for you, " + player_id + ".");
 
		visit_url("clan_viplounge.php?q1=" + get_property("clanFortuneReply1") + "&q2=" + get_property("clanFortuneReply2") + "&q3=" + get_property("clanFortuneReply3") + "&preaction=dotestlove&testlove=" + player_id);
	}
}

void consultZatara(string target_player) {
	cli_execute("fortune " + target_player);
}

void consultingPlayer(string target_player) {
	print_html("Consulting with Zatara about " + target_player);
	consultZatara(target_player);
}

void main() {
	//Ask about each player given
	if(get_property("_clanFortuneConsultUses") < 3) {
		enumerateClannies();
	
		foreach key in clannies {
			if(get_property("_clanFortuneConsultUses") >= 3) { break; }
			consultingPlayer(clannies[key]);
		}
	}
	print("Consulted out.");
	
	//Also check if there are any active consultations waiting
	consultbotAnswerQuestions();
	print("All loves checked.");
}
