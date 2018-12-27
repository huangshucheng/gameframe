local Room = class('Room')

function Room:start_step_none()
	print('Room:start_step_none..........')
end

function Room:start_step_start_game()
	print('Room:start_step_start_game..........')
end

function Room:start_step_ante()
	print('Room:start_step_ante..........')
end

function Room:start_step_specf_mah()
	print('Room:start_step_specf_mah..........')
end

function Room:start_step_throw_chip_1()
	print('Room:start_step_throw_chip_1..........')
end

function Room:start_step_throw_chip_2()
	print('Room:start_step_throw_chip_2..........')
end

function Room:start_step_take_first()
	print('Room:start_step_take_first..........')
end

function Room:start_step_throw_chip_3()
	print('Room:start_step_throw_chip_3..........')
end

function Room:start_step_open_mah()
	print('Room:start_step_open_mah..........')
end

function Room:start_step_first_replace()
	print('Room:start_step_first_replace..........')
end

function Room:start_step_play_mah()
	print('Room:start_step_play_mah..........')
end

function Room:start_step_win_lost()
	print('Room:start_step_win_lost..........')
end

function Room:start_step_end_game()
	print('Room:start_step_end_game..........')
end

return Room